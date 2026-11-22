extends Control
## Pantalla de Árbol de Acciones: pestañas por rama, árbol scrolleable 2D a la izquierda y detalle a la derecha.

const GAME_SCENE_PATH: String = "res://scenes/game/game_screen.tscn"

@export var awareness_tab_button: Button
@export var legislation_tab_button: Button
@export var direct_tab_button: Button
@export var tree_canvas: Control
@export var detail_title_label: Label
@export var detail_desc_label: Label
@export var detail_pros_label: Label
@export var detail_cons_label: Label
@export var detail_cost_label: Label
@export var activate_button: Button
@export var hud_bar: PanelContainer
@export var end_game_modal: ColorRect

var _current_branch: GameBalance.BranchType = GameBalance.BranchType.AWARENESS
var _selected_action_id: StringName = &""


func _ready() -> void:
	if awareness_tab_button:
		awareness_tab_button.pressed.connect(func() -> void: _select_branch(GameBalance.BranchType.AWARENESS))
	if legislation_tab_button:
		legislation_tab_button.pressed.connect(func() -> void: _select_branch(GameBalance.BranchType.LEGISLATION))
	if direct_tab_button:
		direct_tab_button.pressed.connect(func() -> void: _select_branch(GameBalance.BranchType.DIRECT_ACTION))

	if tree_canvas:
		tree_canvas.action_selected.connect(_on_action_selected)
	if activate_button:
		activate_button.pressed.connect(_on_activate_pressed)

	if hud_bar:
		hud_bar.set_actions_button_mode(true)
		hud_bar.actions_button_pressed.connect(_on_back_to_city_pressed)

	if end_game_modal:
		end_game_modal.retry_requested.connect(_on_retry_requested)
		end_game_modal.main_menu_requested.connect(_on_main_menu_requested)

	EventBus.tick_completed.connect(func(_t: int) -> void: _refresh_view())
	EventBus.action_activated.connect(func(_id: StringName) -> void: _refresh_view())
	EventBus.game_ended.connect(_on_game_ended)

	_select_branch(GameBalance.BranchType.AWARENESS)


func _select_branch(branch: GameBalance.BranchType) -> void:
	_current_branch = branch
	var branch_actions := GameManager.simulation.catalog.get_actions_by_branch(branch)
	_selected_action_id = branch_actions[0].id if not branch_actions.is_empty() else &""

	if awareness_tab_button:
		awareness_tab_button.disabled = branch == GameBalance.BranchType.AWARENESS
	if legislation_tab_button:
		legislation_tab_button.disabled = branch == GameBalance.BranchType.LEGISLATION
	if direct_tab_button:
		direct_tab_button.disabled = branch == GameBalance.BranchType.DIRECT_ACTION

	_refresh_view()


func _refresh_view() -> void:
	var branch_actions := GameManager.simulation.catalog.get_actions_by_branch(_current_branch)
	if tree_canvas:
		tree_canvas.build_tree(branch_actions, _selected_action_id)
	_refresh_detail_panel()


func _refresh_detail_panel() -> void:
	var sim := GameManager.simulation
	var action := sim.catalog.get_action(_selected_action_id)

	if action == null:
		if detail_title_label:
			detail_title_label.text = "Selecciona una acción"
		if detail_desc_label:
			detail_desc_label.text = ""
		if detail_pros_label:
			detail_pros_label.text = ""
		if detail_cons_label:
			detail_cons_label.text = ""
		if detail_cost_label:
			detail_cost_label.text = ""
		if activate_button:
			activate_button.disabled = true
			activate_button.text = "Activar"
		return

	if detail_title_label:
		detail_title_label.text = action.title
	if detail_desc_label:
		detail_desc_label.text = action.description
	if detail_pros_label:
		detail_pros_label.text = "Ventajas: %s" % action.pros_text
	if detail_cons_label:
		detail_cons_label.text = "Riesgos: %s" % action.cons_text

	var delay_str := "%d ticks" % action.delay_ticks if action.delay_ticks > 0 else "Inmediato"
	if detail_cost_label:
		detail_cost_label.text = "Coste: $%d  |  Mantenimiento: $%d/mes  |  Activación: %s" % [
			action.cost_budget,
			action.maintenance_per_tick,
			delay_str,
		]

	var status := sim.get_action_status(action.id)
	if activate_button:
		activate_button.disabled = not sim.can_activate_action(action.id)
		match status:
			SimulationEngine.ActionStatus.ACTIVE:
				activate_button.text = "Política Activa"
			SimulationEngine.ActionStatus.MATURING:
				activate_button.text = "Madurando (%d)" % sim.get_action_remaining_delay(action.id)
			SimulationEngine.ActionStatus.SUSPENDED:
				activate_button.text = "Suspendida (Sin Presupuesto)"
			SimulationEngine.ActionStatus.DESTROYED:
				activate_button.text = "Reconstruir ($%d)" % action.cost_budget
			SimulationEngine.ActionStatus.LOCKED:
				activate_button.text = "Requiere Acción Previa"
			_:
				activate_button.text = "Activar ($%d)" % action.cost_budget


func _on_action_selected(action_id: StringName) -> void:
	_selected_action_id = action_id
	_refresh_view()


func _on_activate_pressed() -> void:
	if _selected_action_id != &"":
		GameManager.activate_action(_selected_action_id)
		_refresh_view()


func _on_back_to_city_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_game_ended(result: int) -> void:
	if end_game_modal:
		var sim := GameManager.simulation
		end_game_modal.show_result(result, GameManager.current_tick, sim.get_environmental_health(), sim.trust)


func _on_retry_requested() -> void:
	GameManager.start_new_game()
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_main_menu_requested() -> void:
	GameManager.stop_game()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
