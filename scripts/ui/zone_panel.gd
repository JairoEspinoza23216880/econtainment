extends PanelContainer
## Panel placeholder que representa una de las 3 zonas de la ciudad y su estado ecológico.

const DEFAULT_BUBBLE_SCENE: PackedScene = preload("res://scenes/game/zone_bubble.tscn")

@export var zone_id: GameBalance.ZoneId = GameBalance.ZoneId.PRODUCTIVE
@export var zone_title: String = "Zona"

@export var title_label: Label
@export var state_badge_rect: ColorRect
@export var state_label: Label
@export var pollution_bar: ProgressBar
@export var pollution_value_label: Label
@export var pollution_delta_label: Label
@export var spillover_label: Label
@export var bubble_scene: PackedScene
@export var bubble_container: Control


func _ready() -> void:
	if title_label:
		title_label.text = zone_title


## Actualiza la barra, el delta de cambio, el color placeholder y la alerta de derrame.
func update_zone_display(pollution: float, is_spilling: bool, delta: float = 0.0) -> void:
	if pollution_bar:
		pollution_bar.value = pollution
	if pollution_value_label:
		pollution_value_label.text = "Polución: %.0f%%" % pollution
	if spillover_label:
		spillover_label.visible = is_spilling
	_update_delta_label(delta)

	var color := Color(0.85, 0.68, 0.25)
	var state_text := "Normal"
	if pollution <= 20.0:
		color = Color(0.22, 0.68, 0.36)
		state_text = "Sustentable / Sano"
	elif pollution >= GameBalance.SPILLOVER_POLLUTION_THRESHOLD:
		color = Color(0.78, 0.24, 0.22)
		state_text = "Contaminado"

	if state_badge_rect:
		state_badge_rect.color = color
	if state_label:
		state_label.text = state_text
	if pollution_bar:
		_apply_bar_color(pollution_bar, color)


func _apply_bar_color(bar: ProgressBar, fill_color: Color) -> void:
	bar.custom_minimum_size.y = maxf(bar.custom_minimum_size.y, 18.0)
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


func _update_delta_label(delta: float) -> void:
	if pollution_delta_label == null:
		return
	if absf(delta) < 0.05:
		pollution_delta_label.text = ""
		return
	var sign_str := "+" if delta > 0.0 else "-"
	pollution_delta_label.text = "%s%.1f%%" % [sign_str, absf(delta)]
	# Para la polución, bajar (-) es positivo (verde) y subir (+) es negativo (rojo)
	pollution_delta_label.modulate = Color(0.45, 0.92, 0.55) if delta < 0.0 else Color(0.95, 0.4, 0.4)


## Instancia una burbuja interactiva en una posición aleatoria dentro del área visual de la zona.
func spawn_bubble() -> void:
	var scene_to_spawn := bubble_scene if bubble_scene != null else DEFAULT_BUBBLE_SCENE
	var target_container := bubble_container if bubble_container != null else state_badge_rect
	if scene_to_spawn == null or target_container == null:
		return

	var bubble: Button = scene_to_spawn.instantiate()
	target_container.add_child(bubble)
	bubble.setup(zone_id)

	var max_x := maxf(8.0, target_container.size.x - bubble.custom_minimum_size.x - 8.0)
	var max_y := maxf(8.0, target_container.size.y - bubble.custom_minimum_size.y - 8.0)
	bubble.position = Vector2(randf_range(8.0, max_x), randf_range(8.0, max_y))
