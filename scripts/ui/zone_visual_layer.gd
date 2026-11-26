class_name ZoneVisualLayer
extends Node2D
## Genera y actualiza gradualmente los sprites (fábricas, casas o árboles) dentro de un Polygon2D.

const DEFAULT_BUBBLE_SCENE: PackedScene = preload("res://scenes/game/zone_bubble.tscn")

@export var zone_id: GameBalance.ZoneId = GameBalance.ZoneId.PRODUCTIVE
@export var area_polygon: Polygon2D
@export var prop_count: int = 10
@export var prop_scale: float = 0.22
@export var min_spacing: float = 48.0
@export var bubble_scene: PackedScene

const NEUTRAL_POLLUTION_CENTER: float = 35.0
const HEALTHY_SPAN: float = 35.0
const POLLUTED_SPAN: float = 65.0

var _props: Array[Dictionary] = []
var _last_pollution: float = -1.0
var _avoid_rect: Rect2 = Rect2()


## Define un rectángulo (ej. tarjeta de contaminación) donde conviene evitar colocar burbujas.
func set_avoid_rect(rect: Rect2) -> void:
	_avoid_rect = rect


func _ready() -> void:
	y_sort_enabled = true
	if area_polygon:
		# Ocultamos el relleno guía del editor durante la partida
		area_polygon.color.a = 0.0
	_generate_props()


## Regenera las posiciones y variantes aleatorias de los objetos manteniendo el estado actual.
func regenerate_props() -> void:
	for entry: Dictionary in _props:
		var sprite: Sprite2D = entry.get("sprite", null)
		if sprite != null and is_instance_valid(sprite):
			sprite.queue_free()
	_props.clear()

	var current_pollution := _last_pollution if _last_pollution >= 0.0 else NEUTRAL_POLLUTION_CENTER
	_last_pollution = -1.0
	_generate_props()
	update_pollution(current_pollution)


## Actualiza gradualmente el estilo visual de los objetos según el porcentaje de polución.
func update_pollution(pollution: float) -> void:
	if _props.is_empty():
		return

	# Punto central Normal = 35%; solo en 0% están todos Sanos y solo en 100% están todos Contaminados
	var healthy_ratio := clampf((NEUTRAL_POLLUTION_CENTER - pollution) / HEALTHY_SPAN, 0.0, 1.0)
	var polluted_ratio := clampf((pollution - NEUTRAL_POLLUTION_CENTER) / POLLUTED_SPAN, 0.0, 1.0)

	var total := _props.size()
	for i: int in range(total):
		var entry: Dictionary = _props[i]
		var t: float = entry["threshold"]
		var target_state := &"normal"
		if healthy_ratio > 0.0 and t <= healthy_ratio:
			target_state = &"healthy"
		elif polluted_ratio > 0.0 and t <= polluted_ratio:
			target_state = &"polluted"

		if entry["state"] != target_state:
			entry["state"] = target_state
			var sprite: Sprite2D = entry["sprite"]
			var variants: Dictionary = entry["variants"]
			sprite.texture = variants[target_state]
			if _last_pollution >= 0.0:
				_play_pop_animation(sprite)

	_last_pollution = pollution


## Instancia una burbuja interactiva en un punto aleatorio dentro del polígono evitando la tarjeta de UI.
func spawn_bubble() -> void:
	if area_polygon == null or area_polygon.polygon.size() < 3:
		return

	var pos := _sample_bubble_position()
	var uid := GameManager.register_bubble(zone_id, pos, GameBalance.BUBBLE_LIFETIME_SECONDS)
	restore_bubble(uid, pos, GameBalance.BUBBLE_LIFETIME_SECONDS)


## Reinstancia una burbuja persistida al regresar a GameScreen desde ActionsScreen.
func restore_bubble(uid: int, center_pos: Vector2, remaining_lifetime: float) -> void:
	var scene_to_spawn := bubble_scene if bubble_scene != null else DEFAULT_BUBBLE_SCENE
	if scene_to_spawn == null:
		return

	var bubble: Button = scene_to_spawn.instantiate()
	add_child(bubble)
	bubble.setup(zone_id, uid, remaining_lifetime)
	bubble.position = center_pos - bubble.custom_minimum_size * 0.5


func _sample_bubble_position() -> Vector2:
	var expanded_avoid := _avoid_rect.grow(28.0) if _avoid_rect.has_area() else Rect2()
	var fallback := _sample_point_in_polygon(area_polygon.polygon) + area_polygon.position
	if not expanded_avoid.has_area():
		return fallback

	for _i: int in range(32):
		var candidate := _sample_point_in_polygon(area_polygon.polygon) + area_polygon.position
		if not expanded_avoid.has_point(candidate):
			return candidate
	return fallback


func _generate_props() -> void:
	if area_polygon == null or area_polygon.polygon.size() < 3:
		return

	var variant_sets := _load_zone_variant_sets()
	if variant_sets.is_empty():
		return

	var points := _sample_spaced_points(area_polygon.polygon, prop_count, min_spacing)
	var offset_pos := area_polygon.position
	# Umbrales en (0.0, 1.0]: el último objeto (1.0) solo cambia al llegar exactamente a 0% o 100%
	var thresholds: Array[float] = []
	for i: int in range(points.size()):
		thresholds.append(float(i + 1) / float(maxi(1, points.size())))
	thresholds.shuffle()

	for i: int in range(points.size()):
		var variants: Dictionary = variant_sets[i % variant_sets.size()]
		var sprite := Sprite2D.new()
		sprite.position = points[i] + offset_pos
		sprite.scale = Vector2(prop_scale, prop_scale)
		sprite.texture = variants[&"normal"]
		# Anclamos visualmente hacia la base para que el Y-sort respete la perspectiva
		if sprite.texture != null:
			sprite.offset = Vector2(0.0, -sprite.texture.get_height() * 0.35)
		add_child(sprite)

		_props.append({
			"sprite": sprite,
			"variants": variants,
			"threshold": thresholds[i],
			"state": &"normal",
		})


func _play_pop_animation(sprite: Sprite2D) -> void:
	var tween := create_tween()
	var base := Vector2(prop_scale, prop_scale)
	tween.tween_property(sprite, "scale", base * 1.15, 0.12)
	tween.tween_property(sprite, "scale", base, 0.16)


## Distribuye puntos uniformemente dentro del polígono usando muestreo de mejor candidato (blue-noise).
func _sample_spaced_points(poly: PackedVector2Array, count: int, _spacing: float) -> Array[Vector2]:
	var chosen: Array[Vector2] = []
	if count <= 0:
		return chosen

	chosen.append(_sample_point_in_polygon(poly))
	const CANDIDATES_PER_POINT: int = 24

	while chosen.size() < count:
		var best_candidate := chosen[0]
		var best_min_dist := -1.0

		for _k: int in range(CANDIDATES_PER_POINT):
			var candidate := _sample_point_in_polygon(poly)
			var nearest_dist := INF
			for existing: Vector2 in chosen:
				nearest_dist = minf(nearest_dist, candidate.distance_squared_to(existing))
			if nearest_dist > best_min_dist:
				best_min_dist = nearest_dist
				best_candidate = candidate

		chosen.append(best_candidate)

	return chosen


func _sample_point_in_polygon(poly: PackedVector2Array) -> Vector2:
	var min_pt := poly[0]
	var max_pt := poly[0]
	for p: Vector2 in poly:
		min_pt.x = minf(min_pt.x, p.x)
		min_pt.y = minf(min_pt.y, p.y)
		max_pt.x = maxf(max_pt.x, p.x)
		max_pt.y = maxf(max_pt.y, p.y)

	for _i: int in range(64):
		var candidate := Vector2(randf_range(min_pt.x, max_pt.x), randf_range(min_pt.y, max_pt.y))
		if Geometry2D.is_point_in_polygon(candidate, poly):
			return candidate

	return (min_pt + max_pt) * 0.5


func _load_zone_variant_sets() -> Array[Dictionary]:
	var sets: Array[Dictionary] = []
	match zone_id:
		GameBalance.ZoneId.PRODUCTIVE:
			for idx: int in [1, 2, 3]:
				sets.append({
					&"healthy": load("res://assets/Productzone/Assets_ZonaIndustrial_Fabrica%d_Sana.png" % idx),
					&"normal": load("res://assets/Productzone/Assets_ZonaIndustrial_Fabrica%d_Normal.png" % idx),
					&"polluted": load("res://assets/Productzone/Assets_ZonaIndustrial_Fabrica%d_Contaminada.png" % idx),
				})
		GameBalance.ZoneId.URBAN:
			for idx: int in [1, 2, 3, 4, 5]:
				sets.append({
					&"healthy": load("res://assets/Urbanzone/Assets_ZonaHabitacional_Casa%d_Sostenible.png" % idx),
					&"normal": load("res://assets/Urbanzone/Assets_ZonaHabitacional_Casa%d_Normal.png" % idx),
					&"polluted": load("res://assets/Urbanzone/Assets_ZonaHabitacional_Casa%d_Contaminada.png" % idx),
				})
		GameBalance.ZoneId.RESERVE:
			sets.append({
				&"healthy": load("res://assets/Reservezone/Assets_Reserva_Arbol1_Sano.png"),
				&"normal": load("res://assets/Reservezone/Assets_Reserva_Arbol1_Normal.png"),
				&"polluted": load("res://assets/Reservezone/Assets_Reserva_Arbol1_Contaminado1.png"),
			})
			sets.append({
				&"healthy": load("res://assets/Reservezone/Assets_Reserva_Arbol2_Sano.png"),
				&"normal": load("res://assets/Reservezone/Assets_Reserva_Arbol2_Normal.png"),
				&"polluted": load("res://assets/Reservezone/Assets_Reserva_Arbol2_Contaminado.png"),
			})
			sets.append({
				&"healthy": load("res://assets/Reservezone/Assets_Reserva_Pino_Sano.png"),
				&"normal": load("res://assets/Reservezone/Assets_Reserva_Pino_Normal.png"),
				&"polluted": load("res://assets/Reservezone/Assets_Reserva_Pino_Contaminado.png"),
			})
	return sets
