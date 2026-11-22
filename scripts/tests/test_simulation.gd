extends SceneTree
## Suite de pruebas automatizadas en modo headless para validar SimulationEngine.

var _failures: int = 0


func _init() -> void:
	print("=== Iniciando pruebas de SimulationEngine ===")
	_test_initial_state()
	_test_net_negative_pollution()
	_test_spillover_to_reserve()
	_test_victory_condition()
	_test_defeat_collapse()
	_test_defeat_dismissal()

	if _failures == 0:
		print("=== TODAS LAS PRUEBAS PASARON ===")
		quit(0)
	else:
		printerr("=== PRUEBAS FALLIDAS: %d ===" % _failures)
		quit(1)


func _assert_true(condition: bool, test_name: String, detail: String = "") -> void:
	if condition:
		print("[PASS] %s" % test_name)
	else:
		_failures += 1
		printerr("[FAIL] %s %s" % [test_name, detail])


func _test_initial_state() -> void:
	var engine := SimulationEngine.new()
	var expected_health := 100.0 - (
		GameBalance.INITIAL_PRODUCTIVE_POLLUTION
		+ GameBalance.INITIAL_URBAN_POLLUTION
		+ GameBalance.INITIAL_RESERVE_POLLUTION
	) / 3.0

	_assert_true(
		is_equal_approx(engine.get_environmental_health(), expected_health),
		"test_initial_state_health",
		"Esperado %.2f, obtenido %.2f" % [expected_health, engine.get_environmental_health()]
	)
	_assert_true(
		is_equal_approx(engine.trust, GameBalance.INITIAL_TRUST),
		"test_initial_state_trust"
	)
	_assert_true(
		engine.budget == GameBalance.INITIAL_BUDGET,
		"test_initial_state_budget"
	)


func _test_net_negative_pollution() -> void:
	var engine := SimulationEngine.new()
	var productive: ZoneState = engine.zones[GameBalance.ZoneId.PRODUCTIVE]
	var initial_pollution := productive.pollution
	# Aplicamos mitigación superior a las emisiones base
	productive.mitigation_rate = productive.emission_rate + 5.0
	engine.step_tick()

	_assert_true(
		productive.pollution < initial_pollution,
		"test_net_negative_pollution",
		"Inicial %.2f, actual %.2f" % [initial_pollution, productive.pollution]
	)


func _test_spillover_to_reserve() -> void:
	var engine := SimulationEngine.new()
	var productive: ZoneState = engine.zones[GameBalance.ZoneId.PRODUCTIVE]
	var reserve: ZoneState = engine.zones[GameBalance.ZoneId.RESERVE]

	# Forzamos contaminación > 50% en Productiva y desactivamos emisiones/regen para aislar el derrame
	productive.pollution = 70.0
	productive.emission_rate = 0.0
	reserve.pollution = 10.0
	reserve.regen_rate = 0.0

	var summary := engine.step_tick()
	var spillovers: Dictionary = summary["spillovers"]

	_assert_true(
		spillovers.has(GameBalance.ZoneId.PRODUCTIVE) and reserve.pollution > 10.0,
		"test_spillover_to_reserve",
		"Reserva actual: %.2f" % reserve.pollution
	)


func _test_victory_condition() -> void:
	var engine := SimulationEngine.new()
	for zone: ZoneState in engine.zones.values():
		zone.pollution = 0.0
		zone.emission_rate = 0.0
	engine.trust = 80.0

	var summary := engine.step_tick()
	_assert_true(
		summary["game_result"] == GameBalance.GameResult.VICTORY,
		"test_victory_condition",
		"Resultado obtenido: %d" % summary["game_result"]
	)


func _test_defeat_collapse() -> void:
	var engine := SimulationEngine.new()
	for zone: ZoneState in engine.zones.values():
		zone.pollution = 100.0
		zone.mitigation_rate = 0.0
		zone.regen_rate = 0.0

	var summary := engine.step_tick()
	_assert_true(
		summary["game_result"] == GameBalance.GameResult.DEFEAT_COLLAPSE,
		"test_defeat_collapse",
		"Resultado obtenido: %d" % summary["game_result"]
	)


func _test_defeat_dismissal() -> void:
	var engine := SimulationEngine.new()
	engine.trust = 0.0

	var summary := engine.step_tick()
	_assert_true(
		summary["game_result"] == GameBalance.GameResult.DEFEAT_DISMISSAL,
		"test_defeat_dismissal",
		"Resultado obtenido: %d" % summary["game_result"]
	)
