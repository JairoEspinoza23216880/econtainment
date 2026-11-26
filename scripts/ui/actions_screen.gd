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
@export var repeal_button: Button
@export var hud_bar: PanelContainer
@export var end_game_modal: ColorRect
@export var finance_modal: ColorRect

var _current_branch: GameBalance.BranchType = GameBalance.BranchType.AWARENESS
var _selected_action_id: StringName = &""


func _ready() -> void:
	# Pausamos forzadamente al entrar al menú de acciones para leer sin prisas
	GameManager.enter_actions_screen()

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
	if repeal_button:
		repeal_button.pressed.connect(_on_repeal_pressed)

	if hud_bar:
		hud_bar.set_actions_button_mode(true)
		hud_bar.set_time_controls_locked(true)
		hud_bar.actions_button_pressed.connect(_on_back_to_city_pressed)
		hud_bar.finance_button_pressed.connect(_on_finance_button_pressed)

	if end_game_modal:
		end_game_modal.retry_requested.connect(_on_retry_requested)
		end_game_modal.main_menu_requested.connect(_on_main_menu_requested)

	EventBus.tick_completed.connect(func(_t: int) -> void: _refresh_view())
	EventBus.action_activated.connect(func(_id: StringName) -> void: _refresh_view())
	EventBus.action_repealed.connect(func(_id: StringName) -> void: _refresh_view())
	EventBus.game_ended.connect(_on_game_ended)

	_select_branch(GameManager.last_actions_branch)


func _select_branch(branch: GameBalance.BranchType) -> void:
	_current_branch = branch
	GameManager.last_actions_branch = branch
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
		if repeal_button:
			repeal_button.visible = false
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
	var rule_notes: PackedStringArray = []
	if action.requires_positive_budget:
		rule_notes.append("⚠ Se suspende si presupuesto = $0")
	if action.vulnerable_to_severe_spill:
		rule_notes.append("⚠ Vulnerable a derrame severo")
	if action.budget_income_penalty > 0:
		rule_notes.append("⚠ Penaliza ingreso -$%d/mes" % action.budget_income_penalty)

	var cost_text := "Coste: $%d  |  Mantenimiento: $%d/mes  |  Activación: %s" % [
		action.cost_budget,
		action.maintenance_per_tick,
		delay_str,
	]
	if not rule_notes.is_empty():
		cost_text += "\n" + "  •  ".join(rule_notes)

	if detail_cost_label:
		detail_cost_label.text = cost_text

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

	if repeal_button:
		var is_repealable_status := (
			status == SimulationEngine.ActionStatus.ACTIVE
			or status == SimulationEngine.ActionStatus.SUSPENDED
		)
		repeal_button.visible = is_repealable_status
		if is_repealable_status:
			var can_repeal := sim.can_repeal_action(action.id)
			repeal_button.disabled = not can_repeal
			repeal_button.text = "Derogar Política" if can_repeal else "Deroga primero políticas dependientes"


func _on_action_selected(action_id: StringName) -> void:
	_selected_action_id = action_id
	_refresh_view()


func _on_activate_pressed() -> void:
	if _selected_action_id != &"":
		GameManager.activate_action(_selected_action_id)
		_refresh_view()


func _on_repeal_pressed() -> void:
	if _selected_action_id != &"":
		GameManager.repeal_action(_selected_action_id)
		_refresh_view()


func _on_finance_button_pressed() -> void:
	if finance_modal:
		finance_modal.open_breakdown(GameManager.simulation.get_finance_breakdown())


func _on_back_to_city_pressed() -> void:
	GameManager.exit_actions_screen()
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_game_ended(result: int) -> void:
	if end_game_modal:
		var sim := GameManager.simulation
		end_game_modal.show_result(result, GameManager.current_tick, sim.get_environmental_health(), sim.trust)


func _on_retry_requested() -> void:
	GameManager.start_new_game()
	GameManager.has_seen_welcome = true
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_main_menu_requested() -> void:
	GameManager.stop_game()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
