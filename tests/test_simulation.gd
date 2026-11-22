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
