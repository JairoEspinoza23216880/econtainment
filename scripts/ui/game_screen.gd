extends Control
## Pantalla principal de juego: muestra las 3 zonas de la ciudad arriba y la barra de GUI abajo.

const ACTIONS_SCENE_PATH: String = "res://scenes/actions/actions_screen.tscn"
const MAIN_MENU_PATH: String = "res://scenes/main_menu/main_menu.tscn"

@export var menu_button: Button
@export var productive_panel: PanelContainer
@export var urban_panel: PanelContainer
@export var reserve_panel: PanelContainer
@export var spillover_arrow_label: Label
@export var hud_bar: PanelContainer
@export var pause_menu: ColorRect
@export var end_game_modal: ColorRect
@export var welcome_modal: ColorRect
@export var finance_modal: ColorRect


func _ready() -> void:
	if menu_button:
		menu_button.pressed.connect(_on_menu_button_pressed)
	if hud_bar:
		hud_bar.set_actions_button_mode(false)
		hud_bar.set_time_controls_locked(false)
		hud_bar.actions_button_pressed.connect(_on_actions_button_pressed)
		hud_bar.finance_button_pressed.connect(_on_finance_button_pressed)
	if pause_menu:
		pause_menu.resumed.connect(_on_pause_resumed)
		pause_menu.quit_to_menu_requested.connect(_on_quit_to_menu)
	if end_game_modal:
		end_game_modal.retry_requested.connect(_on_retry_requested)
		end_game_modal.main_menu_requested.connect(_on_quit_to_menu)

	EventBus.zone_updated.connect(_on_zone_updated)
	EventBus.game_ended.connect(_on_game_ended)

	_sync_all_zones()

	# Mostramos el resumen inicial una sola vez al comenzar la partida
	if welcome_modal and not GameManager.has_seen_welcome:
		welcome_modal.visible = true


func _sync_all_zones() -> void:
	var zones := GameManager.simulation.zones
	for zone_id: int in zones.keys():
		var zone: ZoneState = zones[zone_id]
		_on_zone_updated(zone_id, zone.pollution)


func _on_zone_updated(zone_id: int, pollution: float) -> void:
	var is_spilling := zone_id != GameBalance.ZoneId.RESERVE and pollution > GameBalance.SPILLOVER_POLLUTION_THRESHOLD
	var zone: ZoneState = GameManager.simulation.zones.get(zone_id, null)
	var delta := zone.last_delta if zone != null else 0.0
	match zone_id:
		GameBalance.ZoneId.PRODUCTIVE:
			if productive_panel:
				productive_panel.update_zone_display(pollution, is_spilling, delta)
		GameBalance.ZoneId.URBAN:
			if urban_panel:
				urban_panel.update_zone_display(pollution, is_spilling, delta)
		GameBalance.ZoneId.RESERVE:
			if reserve_panel:
				reserve_panel.update_zone_display(pollution, false, delta)

	_update_spillover_indicator()


func _update_spillover_indicator() -> void:
	if not spillover_arrow_label:
		return
	var zones := GameManager.simulation.zones
	var prod: ZoneState = zones[GameBalance.ZoneId.PRODUCTIVE]
	var urb: ZoneState = zones[GameBalance.ZoneId.URBAN]
	var any_spilling := (
		prod.pollution > GameBalance.SPILLOVER_POLLUTION_THRESHOLD
		or urb.pollution > GameBalance.SPILLOVER_POLLUTION_THRESHOLD
	)
	spillover_arrow_label.text = "▼ DERRAME ACTIVO HACIA LA RESERVA ▼" if any_spilling else "↓ Drenaje controlado (<= 50%) ↓"
	spillover_arrow_label.modulate = Color(1.0, 0.35, 0.35) if any_spilling else Color(0.75, 0.85, 0.8)


func _on_actions_button_pressed() -> void:
	get_tree().change_scene_to_file(ACTIONS_SCENE_PATH)


func _on_finance_button_pressed() -> void:
	if finance_modal:
		finance_modal.open_breakdown(GameManager.simulation.get_finance_breakdown())


func _on_menu_button_pressed() -> void:
	GameManager.set_paused(true)
	if pause_menu:
		pause_menu.visible = true


func _on_pause_resumed() -> void:
	if pause_menu:
		pause_menu.visible = false
	GameManager.set_paused(false)


func _on_retry_requested() -> void:
	if end_game_modal:
		end_game_modal.visible = false
	GameManager.start_new_game()
	GameManager.has_seen_welcome = true
	_sync_all_zones()


func _on_quit_to_menu() -> void:
	GameManager.stop_game()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func _on_game_ended(result: int) -> void:
	if end_game_modal:
		var sim := GameManager.simulation
		end_game_modal.show_result(result, GameManager.current_tick, sim.get_environmental_health(), sim.trust)
