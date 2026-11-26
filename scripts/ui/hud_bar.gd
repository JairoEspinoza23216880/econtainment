extends PanelContainer
## Barra inferior de GUI compartida entre GameScreen y ActionsScreen.

signal actions_button_pressed
signal finance_button_pressed

@export var actions_button: Button
@export var pause_button: Button
@export var speed_1x_button: Button
@export var speed_2x_button: Button
@export var speed_3x_button: Button
@export var tick_label: Label
@export var tick_progress_bar: ProgressBar
@export var health_bar: ProgressBar
@export var health_value_label: Label
@export var health_delta_label: Label
@export var trust_bar: ProgressBar
@export var trust_value_label: Label
@export var trust_delta_label: Label
@export var budget_value_label: Label
@export var budget_delta_label: Label
@export var finance_button: Button

var _time_controls_locked: bool = false


func _ready() -> void:
	if actions_button:
		actions_button.pressed.connect(func() -> void: actions_button_pressed.emit())
	if pause_button:
		pause_button.pressed.connect(_on_pause_pressed)
	if speed_1x_button:
		speed_1x_button.pressed.connect(func() -> void: GameManager.set_speed_multiplier(GameBalance.SPEED_MULTIPLIER_SLOW))
	if speed_2x_button:
		speed_2x_button.pressed.connect(func() -> void: GameManager.set_speed_multiplier(GameBalance.SPEED_MULTIPLIER_NORMAL))
	if speed_3x_button:
		speed_3x_button.pressed.connect(func() -> void: GameManager.set_speed_multiplier(GameBalance.SPEED_MULTIPLIER_FAST))
	if finance_button:
		finance_button.pressed.connect(func() -> void: finance_button_pressed.emit())

	EventBus.game_state_updated.connect(_on_game_state_updated)
	EventBus.tick_completed.connect(_on_tick_completed)
	EventBus.time_scale_changed.connect(_on_time_scale_changed)

	_apply_tooltips()
	_apply_button_colors()
	# Sincronizamos con el estado actual al instanciar la escena
	_refresh_from_manager()


func _apply_button_colors() -> void:
	# Amarillo ámbar para Acciones (botón principal) y verde dinero para Finanzas
	if actions_button:
		_style_button(actions_button, Color(0.68, 0.49, 0.08, 1.0))
	if finance_button:
		_style_button(finance_button, Color(0.14, 0.48, 0.27, 1.0))


func _style_button(button: Button, base_color: Color, locked: bool = false) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = base_color
	normal.set_corner_radius_all(6)
	normal.set_border_width_all(1)
	normal.border_color = base_color.lightened(0.28)

	var hover := normal.duplicate()
	hover.bg_color = base_color.lightened(0.14)

	var pressed := normal.duplicate()
	pressed.bg_color = base_color.darkened(0.18)

	var disabled := normal.duplicate()
	disabled.bg_color = base_color.darkened(0.45) if locked else base_color
	disabled.bg_color.a = 0.7 if locked else 1.0

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color(0.75, 0.75, 0.75, 0.85) if locked else Color.WHITE)


func _apply_tooltips() -> void:
	if health_bar:
		health_bar.tooltip_text = "Promedio de limpieza de las 3 zonas. Meta de victoria: 100% (0% = Derrota)."
	if trust_bar:
		trust_bar.tooltip_text = "Aprobación social y motor de recaudación. Requiere >70% para ganar (0% = Derrota)."
	if budget_value_label:
		budget_value_label.tooltip_text = "Presupuesto Verde disponible. Revisa «Finanzas» para ver ingresos y mantenimiento."
	if finance_button:
		finance_button.tooltip_text = "Ver desglose de recaudación mensual, rampa fiscal y mantenimiento activo."


func _process(_delta: float) -> void:
	if tick_progress_bar:
		tick_progress_bar.value = GameManager.get_tick_progress() * 100.0


## Configura el texto del botón principal según si estamos en la ciudad o en el árbol de acciones.
func set_actions_button_mode(in_actions_view: bool) -> void:
	if actions_button:
		actions_button.text = "Volver a Ciudad" if in_actions_view else "Acciones"


## Bloquea o desbloquea los controles de tiempo (pausa forzada en ActionsScreen).
func set_time_controls_locked(locked: bool) -> void:
	_time_controls_locked = locked
	_on_time_scale_changed(GameManager.is_paused, GameManager.speed_multiplier)


func _refresh_from_manager() -> void:
	var sim := GameManager.simulation
	_on_game_state_updated(
		sim.get_environmental_health(),
		sim.trust,
		sim.budget,
		GameManager.last_health_delta,
		GameManager.last_trust_delta,
		GameManager.last_budget_delta
	)
	_on_tick_completed(GameManager.current_tick)
	_on_time_scale_changed(GameManager.is_paused, GameManager.speed_multiplier)


func _on_pause_pressed() -> void:
	if not _time_controls_locked:
		GameManager.toggle_pause()


func _on_game_state_updated(
	health: float,
	trust: float,
	budget: int,
	health_delta: float,
	trust_delta: float,
	budget_delta: int
) -> void:
	if health_bar:
		health_bar.value = health
		_update_health_bar_color(health)
	if health_value_label:
		health_value_label.text = "%.0f%%" % health
	_update_float_delta_label(health_delta_label, health_delta, "%")

	if trust_bar:
		trust_bar.value = trust
		_update_trust_bar_color(trust)
	if trust_value_label:
		trust_value_label.text = "%.0f%%" % trust
	_update_float_delta_label(trust_delta_label, trust_delta, "%")

	if budget_value_label:
		budget_value_label.text = "$%d" % budget
	_update_int_delta_label(budget_delta_label, budget_delta)


func _update_health_bar_color(health: float) -> void:
	var color := Color(0.85, 0.68, 0.25)
	if health >= 80.0:
		color = Color(0.22, 0.68, 0.36)
	elif health < 50.0:
		color = Color(0.78, 0.24, 0.22)
	_apply_bar_color(health_bar, color)


func _update_trust_bar_color(trust: float) -> void:
	var color := Color(0.85, 0.68, 0.25)
	if trust > GameBalance.VICTORY_TRUST_THRESHOLD:
		color = Color(0.22, 0.68, 0.36)
	elif trust < 35.0:
		color = Color(0.78, 0.24, 0.22)
	_apply_bar_color(trust_bar, color)


func _apply_bar_color(bar: ProgressBar, fill_color: Color) -> void:
	bar.custom_minimum_size.y = maxf(bar.custom_minimum_size.y, 20.0)
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.06, 0.09, 0.12, 1.0)
	bg.set_corner_radius_all(4)
	bg.content_margin_top = 4
	bg.content_margin_bottom = 4
	var fill := StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.set_corner_radius_all(4)
	bar.add_theme_stylebox_override("background", bg)
	bar.add_theme_stylebox_override("fill", fill)


func _update_float_delta_label(label: Label, delta: float, suffix: String) -> void:
	if label == null:
		return
	if absf(delta) < 0.05:
		label.text = ""
		return
	var sign_str := "+" if delta > 0.0 else "-"
	label.text = "%s%.1f%s" % [sign_str, absf(delta), suffix]
	label.modulate = Color(0.45, 0.92, 0.55) if delta > 0.0 else Color(0.95, 0.4, 0.4)


func _update_int_delta_label(label: Label, delta: int) -> void:
	if label == null:
		return
	if delta == 0:
		label.text = ""
		return
	var sign_str := "+" if delta > 0 else "-"
	label.text = "%s$%d" % [sign_str, absi(delta)]
	label.modulate = Color(0.45, 0.92, 0.55) if delta > 0 else Color(0.95, 0.4, 0.4)


func _on_tick_completed(tick_number: int) -> void:
	if tick_label:
		tick_label.text = "Mes %d" % tick_number


func _on_time_scale_changed(is_paused: bool, speed_multiplier: float) -> void:
	if pause_button:
		pause_button.text = "Reanudar" if is_paused else "Pausa"
		pause_button.disabled = _time_controls_locked
		# Azul para Reanudar (en pausa), Rojo para Pausa (en ejecución)
		var pause_color := Color(0.16, 0.44, 0.72, 1.0) if is_paused else Color(0.64, 0.18, 0.18, 1.0)
		_style_button(pause_button, pause_color, _time_controls_locked)
	if speed_1x_button:
		speed_1x_button.disabled = _time_controls_locked or (not is_paused and is_equal_approx(speed_multiplier, GameBalance.SPEED_MULTIPLIER_SLOW))
	if speed_2x_button:
		speed_2x_button.disabled = _time_controls_locked or (not is_paused and is_equal_approx(speed_multiplier, GameBalance.SPEED_MULTIPLIER_NORMAL))
	if speed_3x_button:
		speed_3x_button.disabled = _time_controls_locked or (not is_paused and is_equal_approx(speed_multiplier, GameBalance.SPEED_MULTIPLIER_FAST))
