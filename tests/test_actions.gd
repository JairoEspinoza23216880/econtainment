@tool
extends McpTestSuite
## Suite de pruebas para el catálogo extensible de acciones y sus reglas en SimulationEngine.

const GameBalanceClass = preload("res://scripts/data/game_balance.gd")
const ActionDataClass = preload("res://scripts/data/action_data.gd")


func _new_engine():
	var engine_script: GDScript = ResourceLoader.load(
		"res://scripts/simulation/simulation_engine.gd",
		"",
		ResourceLoader.CACHE_MODE_IGNORE
	)
	return engine_script.new()


func suite_name() -> String:
	return "actions"


func test_catalog_loads_eighteen_default_actions() -> void:
	var engine = _new_engine()
	var all_actions: Array = engine.catalog.get_all_actions()
	assert_eq(all_actions.size(), 18, "El catálogo debe cargar las 18 acciones desde res://resources/actions/")


func test_prerequisites_and_punitive_trust_penalty() -> void:
	var engine = _new_engine()
	engine.budget = 200

	# No debe permitir activar clausuras sin aprobar antes norma base y restricción de uso de suelo
	assert_false(engine.can_activate_action(&"punitive_closures"), "Clausuras debe requerir cadena previa")
	assert_true(engine.activate_action(&"emission_standards"), "Debe activar la raíz emission_standards")
	assert_true(engine.activate_action(&"restrictive_land_use"), "Debe iniciar maduración de restrictive_land_use")
	engine.step_tick()
	assert_true(engine.can_activate_action(&"punitive_closures"), "Ahora debe permitir punitive_closures")

	var trust_before: float = engine.trust
	assert_true(engine.activate_action(&"punitive_closures"), "Debe activar punitive_closures")
	assert_true(is_equal_approx(engine.trust, trust_before - 12.0), "Clausuras debe restar 12% de Confianza")


func test_maturing_delay_ticks() -> void:
	var engine = _new_engine()
	engine.budget = 200
	engine.activate_action(&"emission_standards")
	engine.activate_action(&"green_tax_incentives")
	engine.step_tick()
	assert_true(engine.activate_action(&"circular_incentives"), "Debe iniciar maduración de Fomento a la Economía Circular")

	assert_eq(engine.get_action_status(&"circular_incentives"), engine.ActionStatus.MATURING)
	assert_eq(engine.get_action_remaining_delay(&"circular_incentives"), 2)

	engine.step_tick()
	assert_eq(engine.get_action_status(&"circular_incentives"), engine.ActionStatus.MATURING)
	assert_eq(engine.get_action_remaining_delay(&"circular_incentives"), 1)

	engine.step_tick()
	assert_eq(engine.get_action_status(&"circular_incentives"), engine.ActionStatus.ACTIVE)
	assert_eq(engine.get_action_remaining_delay(&"circular_incentives"), 0)


func test_infrastructure_suspends_on_zero_budget() -> void:
	var engine = _new_engine()
	engine.budget = 200
	engine.activate_action(&"emergency_crews")
	engine.activate_action(&"stormwater_collectors")
	engine.step_tick()
	assert_eq(engine.get_action_status(&"stormwater_collectors"), engine.ActionStatus.ACTIVE)

	# Forzamos presupuesto 0 y un costo de mantenimiento alto para probar suspensión
	engine.budget = 0
	engine.maintenance_cost_per_tick = 100
	engine.step_tick()
	assert_eq(engine.get_action_status(&"stormwater_collectors"), engine.ActionStatus.SUSPENDED)


func test_river_treatment_plant_destroyed_by_severe_spill() -> void:
	var engine = _new_engine()
	engine.budget = 200
	engine.activate_action(&"emergency_crews")
	engine.activate_action(&"stormwater_collectors")
	engine.step_tick()
	assert_true(engine.activate_action(&"river_treatment_plant"), "Debe iniciar maduración de planta fluvial")

	# Forzamos un derrame severo (> 10 de transferencia: 80 - 50 = 30 * 0.5 = 15)
	var productive = engine.zones[GameBalanceClass.ZoneId.PRODUCTIVE]
	productive.pollution = 80.0
	productive.emission_rate = 0.0

	var summary: Dictionary = engine.step_tick()
	var destroyed: Array = summary["destroyed_actions"]
	assert_true(destroyed.has(&"river_treatment_plant"), "La planta fluvial debe destruirse ante un derrame severo")
	assert_eq(engine.get_action_status(&"river_treatment_plant"), engine.ActionStatus.DESTROYED)
	assert_true(engine.can_activate_action(&"river_treatment_plant"), "Debe permitir reconstruir la planta destruida")


func test_extensible_custom_action_registration() -> void:
	var engine = _new_engine()
	var custom := ActionDataClass.new()
	custom.id = &"custom_solar_subsidy"
	custom.branch = GameBalanceClass.BranchType.DIRECT_ACTION
	custom.title = "Subsidio Solar"
	custom.cost_budget = 10
	custom.urban_emission_delta = -2.0

	engine.catalog.register_action(custom)
	engine.sync_action_states()

	assert_true(engine.can_activate_action(&"custom_solar_subsidy"), "Una nueva acción registrada debe ser activable")
	assert_true(engine.activate_action(&"custom_solar_subsidy"), "Debe activar la acción personalizada")
	assert_eq(engine.get_action_status(&"custom_solar_subsidy"), engine.ActionStatus.ACTIVE)


func test_repeal_action_and_finance_breakdown() -> void:
	var engine = _new_engine()
	engine.budget = 200
	engine.activate_action(&"emission_standards")
	engine.activate_action(&"restrictive_land_use")
	engine.step_tick()

	# No se debe poder derogar la raíz mientras restrictive_land_use siga activa
	assert_false(engine.can_repeal_action(&"emission_standards"), "No debe derogar raíz con hija activa")
	assert_true(engine.can_repeal_action(&"restrictive_land_use"), "Debe poder derogar hoja activa")

	var breakdown_before: Dictionary = engine.get_finance_breakdown()
	assert_gt(breakdown_before["total_maintenance"], 0, "Debe reportar mantenimiento activo")

	assert_true(engine.repeal_action(&"restrictive_land_use"), "Debe derogar restrictive_land_use")
	assert_eq(engine.get_action_status(&"restrictive_land_use"), engine.ActionStatus.AVAILABLE)
	assert_true(engine.can_repeal_action(&"emission_standards"), "Ahora debe permitir derogar la raíz")

	var breakdown_after: Dictionary = engine.get_finance_breakdown()
	assert_true(
		breakdown_after["total_maintenance"] < breakdown_before["total_maintenance"],
		"El mantenimiento total debe bajar tras derogar"
	)
