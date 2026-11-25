extends Button
## Burbuja interactiva temporal que otorga una recompensa específica según la zona donde aparece.

var zone_id: GameBalance.ZoneId = GameBalance.ZoneId.PRODUCTIVE
var _remaining_lifetime: float = GameBalance.BUBBLE_LIFETIME_SECONDS


func _ready() -> void:
	z_index = 10
	mouse_filter = Control.MOUSE_FILTER_STOP
	pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	if GameManager.is_paused:
		return

	_remaining_lifetime -= delta
	if _remaining_lifetime <= 0.0:
		queue_free()
	elif _remaining_lifetime < 2.0:
		# Parpadeo suave de aviso antes de desaparecer
		modulate.a = 0.55 + 0.45 * absf(sin(_remaining_lifetime * 6.0))


## Configura el texto y color de la burbuja según el tipo de zona.
func setup(p_zone_id: GameBalance.ZoneId) -> void:
	zone_id = p_zone_id
	var style := StyleBoxFlat.new()
	style.set_corner_radius_all(24)
	style.set_border_width_all(2)
	style.border_color = Color(1, 1, 1, 0.9)

	match zone_id:
		GameBalance.ZoneId.PRODUCTIVE:
			text = "+$%d" % GameBalance.BUBBLE_BUDGET_REWARD
			style.bg_color = Color(0.82, 0.58, 0.12, 0.95)
		GameBalance.ZoneId.URBAN:
			text = "+%.1f%% CC" % GameBalance.BUBBLE_TRUST_REWARD
			style.bg_color = Color(0.18, 0.52, 0.85, 0.95)
		GameBalance.ZoneId.RESERVE:
			text = "-%.1f%% Pol" % GameBalance.BUBBLE_RESERVE_POLLUTION_REDUCTION
			style.bg_color = Color(0.16, 0.68, 0.42, 0.95)

	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("hover", style)
	add_theme_stylebox_override("pressed", style)


func _on_pressed() -> void:
	GameManager.collect_bubble(zone_id)
	queue_free()
