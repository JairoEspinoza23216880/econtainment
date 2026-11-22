extends PanelContainer
## Barra inferior de GUI compartida entre GameScreen y ActionsScreen.

signal actions_button_pressed

@export var actions_button: Button
@export var pause_button: Button
@export var speed_1x_button: Button
@export var speed_2x_button: Button
@export var tick_label: Label
@export var tick_progress_bar: ProgressBar
@export var health_bar: ProgressBar
@export var health_value_label: Label
@export var trust_bar: ProgressBar
@export var trust_value_label: Label
@export var budget_value_label: Label


func _ready() -> void:
	if actions_button:
		actions_button.pressed.connect(func() -> void: actions_button_pressed.emit())
	if pause_button:
		pause_button.pressed.connect(_on_pause_pressed)
	if speed_1x_button:
		speed_1x_button.pressed.connect(func() -> void: GameManager.set_speed_multiplier(GameBalance.SPEED_MULTIPLIER_NORMAL))
	if speed_2x_button:
		speed_2x_button.pressed.connect(func() -> void: GameManager.set_speed_multiplier(GameBalance.SPEED_MULTIPLIER_FAST))

	EventBus.game_state_updated.connect(_on_game_state_updated)
	EventBus.tick_completed.connect(_on_tick_completed)
	EventBus.time_scale_changed.connect(_on_time_scale_changed)

	# Sincronizamos con el estado actual al instanciar la escena
	_refresh_from_manager()


func _process(_delta: float) -> void:
	if tick_progress_bar:
		tick_progress_bar.value = GameManager.get_tick_progress() * 100.0


## Configura el texto del botón principal según si estamos en la ciudad o en el árbol de acciones.
func set_actions_button_mode(in_actions_view: bool) -> void:
	if actions_button:
		actions_button.text = "Volver a Ciudad" if in_actions_view else "Acciones"


func _refresh_from_manager() -> void:
	var sim := GameManager.simulation
	_on_game_state_updated(sim.get_environmental_health(), sim.trust, sim.budget)
	_on_tick_completed(GameManager.current_tick)
	_on_time_scale_changed(GameManager.is_paused, GameManager.speed_multiplier)


func _on_pause_pressed() -> void:
	GameManager.toggle_pause()


func _on_game_state_updated(health: float, trust: float, budget: int) -> void:
	if health_bar:
		health_bar.value = health
	if health_value_label:
		health_value_label.text = "%.0f%%" % health
	if trust_bar:
		trust_bar.value = trust
	if trust_value_label:
		trust_value_label.text = "%.0f%%" % trust
	if budget_value_label:
		budget_value_label.text = "$%d" % budget


func _on_tick_completed(tick_number: int) -> void:
	if tick_label:
		tick_label.text = "Mes %d" % tick_number


func _on_time_scale_changed(is_paused: bool, speed_multiplier: float) -> void:
	if pause_button:
		pause_button.text = "Reanudar" if is_paused else "Pausa"
	if speed_1x_button:
		speed_1x_button.disabled = not is_paused and is_equal_approx(speed_multiplier, GameBalance.SPEED_MULTIPLIER_NORMAL)
	if speed_2x_button:
		speed_2x_button.disabled = not is_paused and is_equal_approx(speed_multiplier, GameBalance.SPEED_MULTIPLIER_FAST)
