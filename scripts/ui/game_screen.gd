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
@export var tutorial_banner: PanelContainer
@export var tutorial_banner_label: Label
@export var tutorial_banner_close_button: Button

var _banner_timer: float = 0.0


func _ready() -> void:
	# Si se ejecuta GameScreen directamente (F6 en editor), iniciamos la partida automáticamente
	if not GameManager.is_playing:
		GameManager.start_new_game(false)

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
	if tutorial_banner_close_button:
		tutorial_banner_close_button.pressed.connect(_hide_tutorial_banner)

	EventBus.zone_updated.connect(_on_zone_updated)
	EventBus.bubble_spawned.connect(_on_bubble_spawned)
	EventBus.spillover_occurred.connect(_on_spillover_occurred)
	EventBus.budget_depleted.connect(_on_budget_depleted)
	EventBus.action_destroyed.connect(_on_action_destroyed)
	EventBus.game_ended.connect(_on_game_ended)

	_sync_all_zones()

	# Mostramos el resumen inicial solo si el modo tutorial está activo
	if welcome_modal and GameManager.tutorial_enabled and not GameManager.has_seen_welcome:
		welcome_modal.visible = true


func _process(delta: float) -> void:
	if tutorial_banner and tutorial_banner.visible and _banner_timer > 0.0:
		_banner_timer -= delta
		if _banner_timer <= 0.0:
			_hide_tutorial_banner()


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


func _on_bubble_spawned(zone_id: int) -> void:
	match zone_id:
		GameBalance.ZoneId.PRODUCTIVE:
			if productive_panel:
				productive_panel.spawn_bubble()
		GameBalance.ZoneId.URBAN:
			if urban_panel:
				urban_panel.spawn_bubble()
		GameBalance.ZoneId.RESERVE:
			if reserve_panel:
				reserve_panel.spawn_bubble()

	if GameManager.should_show_hint(&"first_bubble"):
		_show_tutorial_banner("¡Toca las burbujas antes de que desaparezcan! Productiva = +$4, Urbana = +2% Confianza, Reserva = -2.5% Polución.")


func _on_spillover_occurred(_from_zone_id: int, _amount: float) -> void:
	if GameManager.should_show_hint(&"first_spillover"):
		_show_tutorial_banner("¡Derrame crítico! Al superar 50% de polución, el excedente se filtra a la Reserva y baja tu Confianza.")


func _on_budget_depleted() -> void:
	if GameManager.should_show_hint(&"first_budget_depleted"):
		_show_tutorial_banner("Presupuesto en $0: las obras dependientes se suspendieron. Revisa «Finanzas» o deroga políticas.")


func _on_action_destroyed(_action_id: StringName) -> void:
	if GameManager.should_show_hint(&"first_destroyed"):
		_show_tutorial_banner("¡Obra destruida por derrame severo! Puedes reconstruirla desde «Acciones».")


func _show_tutorial_banner(message: String) -> void:
	if tutorial_banner == null or tutorial_banner_label == null:
		return
	tutorial_banner_label.text = message
	tutorial_banner.visible = true
	_banner_timer = 8.0


func _hide_tutorial_banner() -> void:
	if tutorial_banner:
		tutorial_banner.visible = false
	_banner_timer = 0.0


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
	GameManager.start_new_game(GameManager.tutorial_enabled)
	GameManager.has_seen_welcome = true
	_hide_tutorial_banner()
	_sync_all_zones()


func _on_quit_to_menu() -> void:
	GameManager.stop_game()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func _on_game_ended(result: int) -> void:
	if end_game_modal:
		var sim := GameManager.simulation
		end_game_modal.show_result(result, GameManager.current_tick, sim.get_environmental_health(), sim.trust)
