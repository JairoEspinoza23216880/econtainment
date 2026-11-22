extends Control
## Lienzo que genera automáticamente la estructura de árbol (raíz abajo) desde ActionData.

signal action_selected(action_id: StringName)

@export var node_button_scene: PackedScene

const NODE_SIZE: Vector2 = Vector2(210.0, 74.0)
const HORIZONTAL_GAP: float = 36.0
const VERTICAL_GAP: float = 52.0
const PADDING: float = 36.0

var _nodes_by_id: Dictionary = {}
var _edges: Array[Array] = []


func _draw() -> void:
	# Dibujamos las líneas de conexión entre prerrequisito (abajo) y acción hija (arriba)
	for edge: Array in _edges:
		var from_pos: Vector2 = edge[0]
		var to_pos: Vector2 = edge[1]
		draw_line(from_pos, to_pos, Color(0.65, 0.75, 0.82, 0.85), 3.0, true)


## Reconstruye visualmente el árbol para la lista de acciones de una rama.
func build_tree(actions: Array[ActionData], selected_id: StringName) -> void:
	_clear_tree()
	if actions.is_empty() or node_button_scene == null:
		return

	var levels := _compute_levels(actions)
	var rows_by_level: Dictionary = {}
	var max_level := 0

	for action: ActionData in actions:
		var level: int = levels.get(action.id, 0)
		max_level = maxi(max_level, level)
		if not rows_by_level.has(level):
			rows_by_level[level] = []
		rows_by_level[level].append(action)

	var max_cols := 1
	for level_actions: Array in rows_by_level.values():
		max_cols = maxi(max_cols, level_actions.size())

	var total_width := maxf(560.0, PADDING * 2.0 + float(max_cols) * NODE_SIZE.x + float(maxi(0, max_cols - 1)) * HORIZONTAL_GAP)
	var total_height := maxf(420.0, PADDING * 2.0 + float(max_level + 1) * NODE_SIZE.y + float(max_level) * VERTICAL_GAP)
	custom_minimum_size = Vector2(total_width, total_height)

	var sim := GameManager.simulation

	# Colocamos nivel 0 abajo y niveles superiores hacia arriba
	for level: int in rows_by_level.keys():
		var row_actions: Array = rows_by_level[level]
		var row_width := float(row_actions.size()) * NODE_SIZE.x + float(maxi(0, row_actions.size() - 1)) * HORIZONTAL_GAP
		var start_x := (total_width - row_width) * 0.5
		var y := total_height - PADDING - float(level + 1) * NODE_SIZE.y - float(level) * VERTICAL_GAP

		for i: int in range(row_actions.size()):
			var action: ActionData = row_actions[i]
			var x := start_x + float(i) * (NODE_SIZE.x + HORIZONTAL_GAP)
			var btn: Button = node_button_scene.instantiate()
			btn.position = Vector2(x, y)
			btn.size = NODE_SIZE
			add_child(btn)

			var status := sim.get_action_status(action.id)
			var delay := sim.get_action_remaining_delay(action.id)
			btn.setup(action, status, delay, action.id == selected_id)
			btn.action_selected.connect(func(id: StringName) -> void: action_selected.emit(id))
			_nodes_by_id[action.id] = btn

	# Calculamos las líneas entre cada acción y sus prerrequisitos
	for action: ActionData in actions:
		if not _nodes_by_id.has(action.id):
			continue
		var child_btn: Control = _nodes_by_id[action.id]
		var child_bottom := child_btn.position + Vector2(NODE_SIZE.x * 0.5, NODE_SIZE.y)
		for req_id: StringName in action.prerequisites:
			if _nodes_by_id.has(req_id):
				var parent_btn: Control = _nodes_by_id[req_id]
				var parent_top := parent_btn.position + Vector2(NODE_SIZE.x * 0.5, 0.0)
				_edges.append([parent_top, child_bottom])

	queue_redraw()


func _compute_levels(actions: Array[ActionData]) -> Dictionary:
	var action_map: Dictionary = {}
	for action: ActionData in actions:
		action_map[action.id] = action

	var levels: Dictionary = {}
	# Iteramos hasta estabilizar profundidades (soporta cualquier orden en el catálogo)
	var changed := true
	var guard := 0
	while changed and guard < 32:
		changed = false
		guard += 1
		for action: ActionData in actions:
			var target_level := 0
			for req_id: StringName in action.prerequisites:
				if action_map.has(req_id):
					target_level = maxi(target_level, levels.get(req_id, 0) + 1)
			if levels.get(action.id, -1) != target_level:
				levels[action.id] = target_level
				changed = true
	return levels


func _clear_tree() -> void:
	_nodes_by_id.clear()
	_edges.clear()
	for child: Node in get_children():
		child.queue_free()
