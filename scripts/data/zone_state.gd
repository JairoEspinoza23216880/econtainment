class_name ZoneState
extends RefCounted
## Estado de contaminación y tasas de cambio de una zona del tablero.

var zone_id: GameBalance.ZoneId
var pollution: float = 0.0
var emission_rate: float = 0.0
var mitigation_rate: float = 0.0
var regen_rate: float = 0.0


func _init(
	p_zone_id: GameBalance.ZoneId,
	p_pollution: float,
	p_emission_rate: float,
	p_mitigation_rate: float = 0.0,
	p_regen_rate: float = 0.0
) -> void:
	zone_id = p_zone_id
	pollution = clampf(p_pollution, 0.0, 100.0)
	emission_rate = p_emission_rate
	mitigation_rate = p_mitigation_rate
	regen_rate = p_regen_rate


## Aplica la ecuación ΔContaminación = Emisiones - Mitigación - RegeneraciónActiva y devuelve el cambio.
func apply_pollution_tick() -> float:
	var previous_pollution := pollution
	var delta := emission_rate - mitigation_rate - regen_rate
	pollution = clampf(pollution + delta, 0.0, 100.0)
	return pollution - previous_pollution


## Devuelve el porcentaje de limpieza ecológica (0 a 100) de esta zona.
func get_cleanliness() -> float:
	return 100.0 - pollution


## Devuelve el estado visual sugerido según el nivel de contaminación actual.
func get_visual_state() -> StringName:
	if pollution <= 20.0:
		return &"healthy"
	if pollution >= GameBalance.SPILLOVER_POLLUTION_THRESHOLD:
		return &"polluted"
	return &"normal"
