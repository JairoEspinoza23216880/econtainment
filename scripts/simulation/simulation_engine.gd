class_name SimulationEngine
extends RefCounted
## Motor de simulación puro y desacoplado de la interfaz gráfica.

const ActionCatalogClass = preload("res://scripts/data/action_catalog.gd")
const ActionDataClass = preload("res://scripts/data/action_data.gd")

enum ActionStatus {
	LOCKED,
	AVAILABLE,
	MATURING,
	ACTIVE,
	SUSPENDED,
	DESTROYED,
}

var catalog: ActionCatalogClass = ActionCatalogClass.new()
var zones: Dictionary = {}
var action_states: Dictionary = {}

var trust: float = GameBalance.INITIAL_TRUST
var budget: int = GameBalance.INITIAL_BUDGET
var tick_count: int = 0
var game_result: GameBalance.GameResult = GameBalance.GameResult.NONE

# Modificadores acumulados por políticas activas
var budget_income_penalty: int = 0
var maintenance_cost_per_tick: int = 0
var last_budget_depleted: bool = false
var early_alert_enabled: bool = false
var missed_alert_multiplier: float = 1.0


func _init(p_load_catalog: bool = true) -> void:
	if p_load_catalog:
		catalog.load_from_directory()
	reset()


## Reinicia todas las métricas, zonas y estados del árbol de acciones.
func reset() -> void:
	tick_count = 0
	trust = GameBalance.INITIAL_TRUST
	budget = GameBalance.INITIAL_BUDGET
	game_result = GameBalance.GameResult.NONE
	budget_income_penalty = 0
	maintenance_cost_per_tick = 0
	last_budget_depleted = false
	early_alert_enabled = false
	missed_alert_multiplier = 1.0

	zones = {
		GameBalance.ZoneId.PRODUCTIVE: ZoneState.new(
			GameBalance.ZoneId.PRODUCTIVE,
			GameBalance.INITIAL_PRODUCTIVE_POLLUTION,
			GameBalance.BASE_EMISSION_PRODUCTIVE
		),
		GameBalance.ZoneId.URBAN: ZoneState.new(
			GameBalance.ZoneId.URBAN,
			GameBalance.INITIAL_URBAN_POLLUTION,
			GameBalance.BASE_EMISSION_URBAN
		),
		GameBalance.ZoneId.RESERVE: ZoneState.new(
			GameBalance.ZoneId.RESERVE,
			GameBalance.INITIAL_RESERVE_POLLUTION,
			GameBalance.BASE_EMISSION_RESERVE,
			0.0,
			GameBalance.BASE_REGEN_RESERVE
		),
	}

	sync_action_states()


## Sincroniza el diccionario de estados con las acciones actuales del catálogo.
func sync_action_states() -> void:
	action_states.clear()
	for action: ActionDataClass in catalog.get_all_actions():
		var initial_status := ActionStatus.AVAILABLE if action.prerequisites.is_empty() else ActionStatus.LOCKED
		action_states[action.id] = {
			"status": initial_status,
			"remaining_delay": 0,
		}


## Devuelve el estado actual (ActionStatus) de una acción; recalcula LOCKED/AVAILABLE dinámicamente.
func get_action_status(action_id: StringName) -> ActionStatus:
	if not action_states.has(action_id):
		return ActionStatus.LOCKED

	var state: Dictionary = action_states[action_id]
	var status: ActionStatus = state["status"]
	if status == ActionStatus.LOCKED and _are_prerequisites_met(action_id):
		status = ActionStatus.AVAILABLE
		state["status"] = status
	return status


## Devuelve los ticks restantes de maduración para una acción en estado MATURING.
func get_action_remaining_delay(action_id: StringName) -> int:
	if not action_states.has(action_id):
		return 0
	return action_states[action_id]["remaining_delay"]


## Indica si el jugador cumple prerrequisitos y presupuesto para activar la acción.
func can_activate_action(action_id: StringName) -> bool:
	var action := catalog.get_action(action_id)
	if action == null:
		return false

	var status := get_action_status(action_id)
	if status != ActionStatus.AVAILABLE and status != ActionStatus.DESTROYED:
		return false

	return budget >= action.cost_budget


## Activa (o reconstruye si fue destruida) una acción del catálogo.
func activate_action(action_id: StringName) -> bool:
	if not can_activate_action(action_id):
		return false

	var action := catalog.get_action(action_id)
	budget -= action.cost_budget
	trust = clampf(trust + action.immediate_trust_delta, 0.0, 100.0)

	if action.delay_ticks > 0:
		action_states[action_id] = {
			"status": ActionStatus.MATURING,
			"remaining_delay": action.delay_ticks,
		}
	else:
		action_states[action_id] = {
			"status": ActionStatus.ACTIVE,
			"remaining_delay": 0,
		}
		_recompute_modifiers()

	_refresh_unlocked_actions()
	return true


## Calcula la Salud Ambiental global (0% - 100%) como el promedio de limpieza de las 3 zonas.
func get_environmental_health() -> float:
	if zones.is_empty():
		return 0.0
	var total_cleanliness := 0.0
	for zone: ZoneState in zones.values():
		total_cleanliness += zone.get_cleanliness()
	return clampf(total_cleanliness / float(zones.size()), 0.0, 100.0)


## Calcula el ingreso de Presupuesto Verde para el tick actual según Confianza y Salud.
func calculate_budget_income() -> int:
	var health_factor := get_environmental_health() / 100.0
	var trust_factor := trust / 100.0
	var multiplier := 0.5 + 0.5 * ((health_factor + trust_factor) * 0.5)
	var raw_income := roundi(float(GameBalance.BASE_BUDGET_INCOME_PER_TICK) * multiplier)
	return maxi(raw_income - budget_income_penalty, GameBalance.MIN_BUDGET_INCOME_PER_TICK)


## Ejecuta un tick completo de simulación y devuelve un diccionario resumen para la UI.
func step_tick() -> Dictionary:
	if game_result != GameBalance.GameResult.NONE:
		return _build_summary({}, [])

	tick_count += 1
	var modifiers_dirty := false

	# 1. Avance de acciones en maduración (ej. Fomento Circular o Humedales)
	if _advance_maturing_actions():
		modifiers_dirty = true

	# 2. Ingreso y mantenimiento de presupuesto
	budget += calculate_budget_income()
	budget -= maintenance_cost_per_tick
	if budget <= 0:
		budget = 0
		last_budget_depleted = true
	else:
		last_budget_depleted = false

	# Suspender o reactivar infraestructuras dependientes de presupuesto > 0
	if _update_budget_dependent_actions():
		modifiers_dirty = true

	if modifiers_dirty:
		_recompute_modifiers()

	# 3. Emisiones vs Mitigación vs Regeneración en cada zona
	for zone: ZoneState in zones.values():
		zone.apply_pollution_tick()

	# 4. Cálculo de derrames hacia la Reserva Biológica si Productiva o Urbana superan 50%
	var spillovers: Dictionary = _apply_spillovers()
	var destroyed_actions: Array[StringName] = _handle_severe_spill_vulnerability(spillovers)

	# 5. Desgaste pasivo de Confianza Ciudadana si la contaminación promedio es alta
	var average_pollution := 100.0 - get_environmental_health()
	if average_pollution > GameBalance.TRUST_DECAY_POLLUTION_THRESHOLD:
		trust = clampf(trust - GameBalance.TRUST_DECAY_PER_TICK, 0.0, 100.0)

	# 6. Verificación de condiciones de Victoria o Derrota
	game_result = evaluate_game_result()

	return _build_summary(spillovers, destroyed_actions)


## Evalúa si se ha cumplido alguna condición de fin de partida.
func evaluate_game_result() -> GameBalance.GameResult:
	var health := get_environmental_health()

	if health <= GameBalance.DEFEAT_THRESHOLD:
		return GameBalance.GameResult.DEFEAT_COLLAPSE

	if trust <= GameBalance.DEFEAT_THRESHOLD:
		return GameBalance.GameResult.DEFEAT_DISMISSAL

	if health >= GameBalance.VICTORY_HEALTH_THRESHOLD and trust > GameBalance.VICTORY_TRUST_THRESHOLD:
		return GameBalance.GameResult.VICTORY

	return GameBalance.GameResult.NONE


func _are_prerequisites_met(action_id: StringName) -> bool:
	var action := catalog.get_action(action_id)
	if action == null:
		return false
	for req_id: StringName in action.prerequisites:
		var req_state: Dictionary = action_states.get(req_id, {})
		if req_state.get("status", ActionStatus.LOCKED) != ActionStatus.ACTIVE:
			return false
	return true


func _refresh_unlocked_actions() -> void:
	for action_id: StringName in action_states.keys():
		get_action_status(action_id)


func _advance_maturing_actions() -> bool:
	var any_activated := false
	for action_id: StringName in action_states.keys():
		var state: Dictionary = action_states[action_id]
		if state["status"] == ActionStatus.MATURING:
			state["remaining_delay"] -= 1
			if state["remaining_delay"] <= 0:
				state["remaining_delay"] = 0
				state["status"] = ActionStatus.ACTIVE
				any_activated = true
	if any_activated:
		_refresh_unlocked_actions()
	return any_activated


func _update_budget_dependent_actions() -> bool:
	var changed := false
	for action_id: StringName in action_states.keys():
		var action := catalog.get_action(action_id)
		if action == null or not action.requires_positive_budget:
			continue

		var state: Dictionary = action_states[action_id]
		if last_budget_depleted and state["status"] == ActionStatus.ACTIVE:
			state["status"] = ActionStatus.SUSPENDED
			changed = true
		elif not last_budget_depleted and state["status"] == ActionStatus.SUSPENDED:
			state["status"] = ActionStatus.ACTIVE
			changed = true
	return changed


func _handle_severe_spill_vulnerability(spillovers: Dictionary) -> Array[StringName]:
	var destroyed: Array[StringName] = []
	var total_spill := 0.0
	for amount: float in spillovers.values():
		total_spill += amount

	if total_spill < GameBalance.SEVERE_SPILLOVER_THRESHOLD:
		return destroyed

	var need_recompute := false
	for action_id: StringName in action_states.keys():
		var action := catalog.get_action(action_id)
		if action == null or not action.vulnerable_to_severe_spill:
			continue

		var state: Dictionary = action_states[action_id]
		if state["status"] == ActionStatus.ACTIVE or state["status"] == ActionStatus.MATURING:
			if state["status"] == ActionStatus.ACTIVE:
				need_recompute = true
			state["status"] = ActionStatus.DESTROYED
			state["remaining_delay"] = 0
			destroyed.append(action_id)

	if need_recompute:
		_recompute_modifiers()

	return destroyed


func _recompute_modifiers() -> void:
	var productive: ZoneState = zones[GameBalance.ZoneId.PRODUCTIVE]
	var urban: ZoneState = zones[GameBalance.ZoneId.URBAN]
	var reserve: ZoneState = zones[GameBalance.ZoneId.RESERVE]

	# Partimos siempre desde los valores base para evitar deriva numérica
	productive.emission_rate = GameBalance.BASE_EMISSION_PRODUCTIVE
	productive.mitigation_rate = 0.0
	productive.regen_rate = 0.0

	urban.emission_rate = GameBalance.BASE_EMISSION_URBAN
	urban.mitigation_rate = 0.0
	urban.regen_rate = 0.0

	reserve.emission_rate = GameBalance.BASE_EMISSION_RESERVE
	reserve.mitigation_rate = 0.0
	reserve.regen_rate = GameBalance.BASE_REGEN_RESERVE

	maintenance_cost_per_tick = 0
	budget_income_penalty = 0
	early_alert_enabled = false
	missed_alert_multiplier = 1.0

	for action_id: StringName in action_states.keys():
		var state: Dictionary = action_states[action_id]
		if state["status"] != ActionStatus.ACTIVE:
			continue

		var action := catalog.get_action(action_id)
		if action == null:
			continue

		productive.emission_rate += action.productive_emission_delta
		productive.mitigation_rate += action.productive_mitigation_delta
		productive.regen_rate += action.productive_regen_delta

		urban.emission_rate += action.urban_emission_delta
		urban.mitigation_rate += action.urban_mitigation_delta
		urban.regen_rate += action.urban_regen_delta

		reserve.emission_rate += action.reserve_emission_delta
		reserve.mitigation_rate += action.reserve_mitigation_delta
		reserve.regen_rate += action.reserve_regen_delta

		maintenance_cost_per_tick += action.maintenance_per_tick
		budget_income_penalty += action.budget_income_penalty
		if action.grants_early_alert:
			early_alert_enabled = true
		missed_alert_multiplier = maxf(missed_alert_multiplier, action.missed_alert_penalty_multiplier)

	# Evitamos tasas negativas por acumulación de reducciones
	for zone: ZoneState in zones.values():
		zone.emission_rate = maxf(0.0, zone.emission_rate)
		zone.mitigation_rate = maxf(0.0, zone.mitigation_rate)
		zone.regen_rate = maxf(0.0, zone.regen_rate)


func _apply_spillovers() -> Dictionary:
	var spillovers: Dictionary = {}
	var reserve_zone: ZoneState = zones[GameBalance.ZoneId.RESERVE]

	for source_id: GameBalance.ZoneId in [GameBalance.ZoneId.PRODUCTIVE, GameBalance.ZoneId.URBAN]:
		var source_zone: ZoneState = zones[source_id]
		if source_zone.pollution > GameBalance.SPILLOVER_POLLUTION_THRESHOLD:
			var excess := source_zone.pollution - GameBalance.SPILLOVER_POLLUTION_THRESHOLD
			var transfer := excess * GameBalance.SPILLOVER_TRANSFER_RATIO
			reserve_zone.pollution = clampf(reserve_zone.pollution + transfer, 0.0, 100.0)
			spillovers[source_id] = transfer

	return spillovers


func _build_summary(spillovers: Dictionary, destroyed_actions: Array[StringName]) -> Dictionary:
	return {
		"tick": tick_count,
		"health": get_environmental_health(),
		"trust": trust,
		"budget": budget,
		"budget_depleted": last_budget_depleted,
		"spillovers": spillovers,
		"destroyed_actions": destroyed_actions,
		"game_result": game_result,
	}
