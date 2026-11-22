extends Button
## Botón individual que representa un nodo configurable dentro del árbol de acciones.

signal action_selected(action_id: StringName)

var action_id: StringName = &""


func _ready() -> void:
	pressed.connect(func() -> void: action_selected.emit(action_id))


## Configura el texto y estilo visual según el ActionData y su estado actual.
func setup(action: ActionData, status: SimulationEngine.ActionStatus, remaining_delay: int, is_selected: bool) -> void:
	action_id = action.id
	var status_tag := _get_status_tag(status, remaining_delay)
	text = "%s\n$%d  •  %s" % [action.title, action.cost_budget, status_tag]

	match status:
		SimulationEngine.ActionStatus.LOCKED:
			modulate = Color(0.55, 0.55, 0.55)
		SimulationEngine.ActionStatus.AVAILABLE:
			modulate = Color(0.95, 0.95, 0.95)
		SimulationEngine.ActionStatus.MATURING:
			modulate = Color(0.95, 0.82, 0.38)
		SimulationEngine.ActionStatus.ACTIVE:
			modulate = Color(0.45, 0.90, 0.55)
		SimulationEngine.ActionStatus.SUSPENDED:
			modulate = Color(0.90, 0.55, 0.30)
		SimulationEngine.ActionStatus.DESTROYED:
			modulate = Color(0.95, 0.35, 0.35)

	if is_selected:
		modulate = modulate.lightened(0.2)


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
