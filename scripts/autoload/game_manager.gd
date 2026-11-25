extends Node
## Gestor principal del flujo de partida, reloj de ticks y puente entre SimulationEngine y EventBus.

var simulation: SimulationEngine = SimulationEngine.new()

var is_playing: bool = false
var is_paused: bool = false
var speed_multiplier: float = GameBalance.SPEED_MULTIPLIER_NORMAL
var current_tick: int = 0
var tick_elapsed: float = 0.0

# Estado de onboarding y pausa contextual en ActionsScreen
var has_seen_welcome: bool = false
var _in_actions_screen: bool = false
var _was_paused_before_actions: bool = true

# Últimos deltas registrados para mantener los indicadores QoL entre escenas
var last_health_delta: float = 0.0
var last_trust_delta: float = 0.0
var last_budget_delta: int = 0


func _process(delta: float) -> void:
	# Solo avanzamos el reloj cuando la partida está activa y sin pausa
	if not is_playing or is_paused:
		return

	tick_elapsed += delta * speed_multiplier
	if tick_elapsed >= GameBalance.TICK_DURATION_SECONDS:
		tick_elapsed -= GameBalance.TICK_DURATION_SECONDS
		_advance_tick()


## Inicia una nueva partida en pausa táctica para que el jugador lea el resumen inicial.
func start_new_game() -> void:
	simulation.reset()
	current_tick = 0
	tick_elapsed = 0.0
	is_paused = true
	speed_multiplier = GameBalance.SPEED_MULTIPLIER_NORMAL
	is_playing = true
	has_seen_welcome = false
	_in_actions_screen = false
	_was_paused_before_actions = true
	last_health_delta = 0.0
	last_trust_delta = 0.0
	last_budget_delta = 0

	EventBus.time_scale_changed.emit(is_paused, speed_multiplier)
	_emit_full_state()


## Detiene la simulación activa (por ejemplo al volver al menú principal).
func stop_game() -> void:
	is_playing = false
	is_paused = false
	_in_actions_screen = false
	tick_elapsed = 0.0


## Fuerza la pausa al entrar a ActionsScreen, guardando si ya estaba pausado antes.
func enter_actions_screen() -> void:
	if not _in_actions_screen:
		_was_paused_before_actions = is_paused
		_in_actions_screen = true
	set_paused(true)


## Restaura el estado de pausa previo al salir de ActionsScreen.
func exit_actions_screen() -> void:
	if _in_actions_screen:
		_in_actions_screen = false
		set_paused(_was_paused_before_actions)


## Intenta activar una acción del árbol y notifica a la UI si tuvo éxito.
func activate_action(action_id: StringName) -> bool:
	if not is_playing:
		return false
	var prev_trust := simulation.trust
	var prev_budget := simulation.budget
	if not simulation.activate_action(action_id):
		return false

	last_trust_delta = simulation.trust - prev_trust
	last_budget_delta = simulation.budget - prev_budget
	EventBus.action_activated.emit(action_id)
	_emit_full_state()
	return true


## Intenta derogar una política activa o suspendida y notifica a la UI.
func repeal_action(action_id: StringName) -> bool:
	if not is_playing:
		return false
	if not simulation.repeal_action(action_id):
		return false

	EventBus.action_repealed.emit(action_id)
	_emit_full_state()
	return true


## Recolecta una burbuja de zona y aplica su recompensa inmediata.
func collect_bubble(zone_id: int) -> void:
	if not is_playing:
		return
	var prev_health := simulation.get_environmental_health()
	var prev_trust := simulation.trust
	var prev_budget := simulation.budget

	simulation.collect_bubble(zone_id as GameBalance.ZoneId)

	last_health_delta = simulation.get_environmental_health() - prev_health
	last_trust_delta = simulation.trust - prev_trust
	last_budget_delta = simulation.budget - prev_budget

	EventBus.bubble_collected.emit(zone_id)
	_emit_full_state()


## Pausa o reanuda el avance automático de ticks.
func set_paused(paused: bool) -> void:
	if is_paused == paused:
		return
	is_paused = paused
	EventBus.time_scale_changed.emit(is_paused, speed_multiplier)


## Alterna entre estado pausado y activo.
func toggle_pause() -> void:
	set_paused(not is_paused)


## Cambia el multiplicador de velocidad de los ticks (1x / 2x / 3x).
func set_speed_multiplier(multiplier: float) -> void:
	speed_multiplier = maxf(multiplier, 0.5)
	EventBus.time_scale_changed.emit(is_paused, speed_multiplier)


## Devuelve el progreso normalizado (0.0 a 1.0) del tick actual para la UI.
func get_tick_progress() -> float:
	if GameBalance.TICK_DURATION_SECONDS <= 0.0:
		return 0.0
	return clampf(tick_elapsed / GameBalance.TICK_DURATION_SECONDS, 0.0, 1.0)


## Cierra la aplicación de forma segura (en WebGL la ventana no se cierra).
func quit_game() -> void:
	get_tree().quit()


func _advance_tick() -> void:
	current_tick += 1
	EventBus.tick_started.emit(current_tick)

	var summary := simulation.step_tick()
	last_health_delta = summary.get("health_delta", 0.0)
	last_trust_delta = summary.get("trust_delta", 0.0)
	last_budget_delta = summary.get("budget_delta", 0)

	# Notificamos derrames ocurridos durante este tick
	var spillovers: Dictionary = summary.get("spillovers", {})
	for source_id: int in spillovers.keys():
		EventBus.spillover_occurred.emit(source_id, spillovers[source_id])

	_emit_full_state()
	EventBus.tick_completed.emit(current_tick)

	# Notificamos burbujas generadas al cierre del tick
	var bubble_spawns: Array = summary.get("bubble_spawns", [])
	for zone_id: int in bubble_spawns:
		EventBus.bubble_spawned.emit(zone_id)

	var result: int = summary.get("game_result", GameBalance.GameResult.NONE)
	if result != GameBalance.GameResult.NONE:
		is_playing = false
		EventBus.game_ended.emit(result)


func _emit_full_state() -> void:
	for zone_id: int in simulation.zones.keys():
		var zone: ZoneState = simulation.zones[zone_id]
		EventBus.zone_updated.emit(zone_id, zone.pollution)

	EventBus.game_state_updated.emit(
		simulation.get_environmental_health(),
		simulation.trust,
		simulation.budget,
		last_health_delta,
		last_trust_delta,
		last_budget_delta
	)
