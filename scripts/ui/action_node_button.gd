extends Button
## Botón individual que representa un nodo configurable dentro del árbol de acciones.

signal action_selected(action_id: StringName)

var action_id: StringName = &""


func _ready() -> void:
	pressed.connect(func() -> void: action_selected.emit(action_id))


## Configura el texto, color por estado y reborde blanco si está seleccionada.
func setup(action: ActionData, status: SimulationEngine.ActionStatus, remaining_delay: int, is_selected: bool) -> void:
	action_id = action.id
	var status_tag := _get_status_tag(status, remaining_delay)
	text = "%s\n$%d  •  %s" % [action.title, action.cost_budget, status_tag]

	var bg_color := Color(0.24, 0.30, 0.36, 1.0)
	match status:
		SimulationEngine.ActionStatus.LOCKED:
			bg_color = Color(0.20, 0.22, 0.25, 0.92)
		SimulationEngine.ActionStatus.AVAILABLE:
			bg_color = Color(0.24, 0.31, 0.38, 1.0)
		SimulationEngine.ActionStatus.MATURING:
			bg_color = Color(0.55, 0.44, 0.14, 1.0)
		SimulationEngine.ActionStatus.ACTIVE:
			bg_color = Color(0.16, 0.46, 0.26, 1.0)
		SimulationEngine.ActionStatus.SUSPENDED:
			bg_color = Color(0.58, 0.32, 0.14, 1.0)
		SimulationEngine.ActionStatus.DESTROYED:
			bg_color = Color(0.56, 0.17, 0.17, 1.0)

	_apply_node_style(bg_color, is_selected)


func _apply_node_style(bg_color: Color, is_selected: bool) -> void:
	modulate = Color.WHITE
	var normal := StyleBoxFlat.new()
	normal.bg_color = bg_color.lightened(0.08) if is_selected else bg_color
	normal.set_corner_radius_all(8)
	if is_selected:
		normal.set_border_width_all(3)
		normal.border_color = Color.WHITE
	else:
		normal.set_border_width_all(1)
		normal.border_color = bg_color.lightened(0.28)

	var hover := normal.duplicate()
	hover.bg_color = normal.bg_color.lightened(0.12)

	var pressed := normal.duplicate()
	pressed.bg_color = normal.bg_color.darkened(0.14)

	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("hover", hover)
	add_theme_stylebox_override("pressed", pressed)
	add_theme_stylebox_override("focus", normal)
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", Color.WHITE)


func _get_status_tag(status: SimulationEngine.ActionStatus, remaining_delay: int) -> String:
	match status:
		SimulationEngine.ActionStatus.LOCKED:
			return "Bloqueada"
		SimulationEngine.ActionStatus.AVAILABLE:
			return "Disponible"
		SimulationEngine.ActionStatus.MATURING:
			return "Madurando (%d)" % remaining_delay
		SimulationEngine.ActionStatus.ACTIVE:
			return "Activa"
		SimulationEngine.ActionStatus.SUSPENDED:
			return "Suspendida"
		SimulationEngine.ActionStatus.DESTROYED:
			return "Destruida"
	return ""
