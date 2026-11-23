@tool
extends McpTestSuite
## Suite de pruebas automatizadas para validar SimulationEngine desde godot-ai test_run.

const GameBalanceClass = preload("res://scripts/data/game_balance.gd")
const SimulationEngineClass = preload("res://scripts/simulation/simulation_engine.gd")


func suite_name() -> String:
	return "simulation"


func test_initial_state() -> void:
	var engine = SimulationEngineClass.new()
	var expected_health := 100.0 - (
		GameBalanceClass.INITIAL_PRODUCTIVE_POLLUTION
		+ GameBalanceClass.INITIAL_URBAN_POLLUTION
		+ GameBalanceClass.INITIAL_RESERVE_POLLUTION
	) / 3.0

	assert_true(
		is_equal_approx(engine.get_environmental_health(), expected_health),
		"Salud inicial incorrecta"
	)
	assert_true(
		is_equal_approx(engine.trust, GameBalanceClass.INITIAL_TRUST),
		"Confianza inicial incorrecta"
	)
	assert_eq(engine.budget, GameBalanceClass.INITIAL_BUDGET, "Presupuesto inicial incorrecto")
	assert_eq(GameBalanceClass.TICK_DURATION_SECONDS, 10.0, "La duración de tick debe ser 10s")
	assert_eq(
		engine.zones[GameBalanceClass.ZoneId.RESERVE].get_visual_state(),
		&"normal",
		"La Reserva debe iniciar en estado normal"
	)


func test_dynamic_trust_by_zone_state() -> void:
	var engine = SimulationEngineClass.new()
	# Todas las zonas en normal (25%-35%): la confianza no debe cambiar
	for zone in engine.zones.values():
		zone.pollution = 30.0
		zone.emission_rate = 0.0
		zone.mitigation_rate = 0.0
		zone.regen_rate = 0.0
	var trust_before: float = engine.trust
	engine.step_tick()
	assert_true(is_equal_approx(engine.trust, trust_before), "Zonas en normal no deben alterar la Confianza")

	# Todas las zonas sanas (<=20%): la confianza debe subir para evitar softlocks
	for zone in engine.zones.values():
		zone.pollution = 10.0
	var summary_healthy: Dictionary = engine.step_tick()
	assert_gt(engine.trust, trust_before, "Zonas sanas deben aumentar la Confianza")
	assert_gt(summary_healthy["trust_delta"], 0.0, "trust_delta debe ser positivo")

	# Zonas contaminadas (>=50%): la confianza debe bajar
	for zone in engine.zones.values():
		zone.pollution = 60.0
	var trust_before_polluted: float = engine.trust
	var summary_polluted: Dictionary = engine.step_tick()
	assert_true(engine.trust < trust_before_polluted, "Zonas contaminadas deben reducir la Confianza")
	assert_true(summary_polluted["trust_delta"] < 0.0, "trust_delta debe ser negativo")


func test_net_negative_pollution() -> void:
	var engine = SimulationEngineClass.new()
	var productive = engine.zones[GameBalanceClass.ZoneId.PRODUCTIVE]
	var initial_pollution: float = productive.pollution
	productive.mitigation_rate = productive.emission_rate + 5.0
	engine.step_tick()

	assert_true(productive.pollution < initial_pollution, "La mitigación neta debería reducir la contaminación")


func test_spillover_to_reserve() -> void:
	var engine = SimulationEngineClass.new()
	var productive = engine.zones[GameBalanceClass.ZoneId.PRODUCTIVE]
	var reserve = engine.zones[GameBalanceClass.ZoneId.RESERVE]

	productive.pollution = 70.0
	productive.emission_rate = 0.0
	reserve.pollution = 10.0
	reserve.regen_rate = 0.0

	var summary: Dictionary = engine.step_tick()
	var spillovers: Dictionary = summary["spillovers"]

	assert_true(spillovers.has(GameBalanceClass.ZoneId.PRODUCTIVE), "Debe registrarse derrame desde Zona Productiva")
	assert_gt(reserve.pollution, 10.0, "La Reserva Biológica debe recibir contaminación por derrame")


func test_victory_condition() -> void:
	var engine = SimulationEngineClass.new()
	for zone in engine.zones.values():
		zone.pollution = 0.0
		zone.emission_rate = 0.0
	engine.trust = 80.0

	var summary: Dictionary = engine.step_tick()
	assert_eq(summary["game_result"], GameBalanceClass.GameResult.VICTORY, "Debe disparar VICTORY")


func test_defeat_collapse() -> void:
	var engine = SimulationEngineClass.new()
	for zone in engine.zones.values():
		zone.pollution = 100.0
		zone.mitigation_rate = 0.0
		zone.regen_rate = 0.0

	var summary: Dictionary = engine.step_tick()
	assert_eq(summary["game_result"], GameBalanceClass.GameResult.DEFEAT_COLLAPSE, "Debe disparar DEFEAT_COLLAPSE")


func test_defeat_dismissal() -> void:
	var engine = SimulationEngineClass.new()
	engine.trust = 0.0

	var summary: Dictionary = engine.step_tick()
	assert_eq(summary["game_result"], GameBalanceClass.GameResult.DEFEAT_DISMISSAL, "Debe disparar DEFEAT_DISMISSAL")
