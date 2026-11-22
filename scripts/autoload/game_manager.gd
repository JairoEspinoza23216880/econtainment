extends Node
## Gestor principal del flujo de partida, reloj de ticks y puente entre SimulationEngine y EventBus.

var simulation: SimulationEngine = SimulationEngine.new()

var is_playing: bool = false
var is_paused: bool = false
var speed_multiplier: float = GameBalance.SPEED_MULTIPLIER_NORMAL
var current_tick: int = 0
var tick_elapsed: float = 0.0


func _process(delta: float) -> void:
	# Solo avanzamos el reloj cuando la partida está activa y sin pausa
	if not is_playing or is_paused:
		return

	tick_elapsed += delta * speed_multiplier
	if tick_elapsed >= GameBalance.TICK_DURATION_SECONDS:
		tick_elapsed -= GameBalance.TICK_DURATION_SECONDS
		_advance_tick()


## Inicia una nueva partida reiniciando la simulación y el reloj de ticks.
func start_new_game() -> void:
	simulation.reset()
	current_tick = 0
	tick_elapsed = 0.0
	is_paused = false
	speed_multiplier = GameBalance.SPEED_MULTIPLIER_NORMAL
	is_playing = true

	EventBus.time_scale_changed.emit(is_paused, speed_multiplier)
	_emit_full_state()


## Detiene la simulación activa (por ejemplo al volver al menú principal).
func stop_game() -> void:
	is_playing = false
	is_paused = false
	tick_elapsed = 0.0


## Intenta activar una acción del árbol y notifica a la UI si tuvo éxito.
func activate_action(action_id: StringName) -> bool:
	if not is_playing:
		return false
	if not simulation.activate_action(action_id):
		return false

	EventBus.action_activated.emit(action_id)
	_emit_full_state()
	return true


## Pausa o reanuda el avance automático de ticks.
func set_paused(paused: bool) -> void:
	if is_paused == paused:
		return
	is_paused = paused
	EventBus.time_scale_changed.emit(is_paused, speed_multiplier)


## Alterna entre estado pausado y activo.
func toggle_pause() -> void:
	set_paused(not is_paused)


## Cambia el multiplicador de velocidad de los ticks (1x / 2x).
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

	# Notificamos derrames ocurridos durante este tick
	var spillovers: Dictionary = summary.get("spillovers", {})
	for source_id: int in spillovers.keys():
		EventBus.spillover_occurred.emit(source_id, spillovers[source_id])

	_emit_full_state()
	EventBus.tick_completed.emit(current_tick)

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
		simulation.budget
	)
