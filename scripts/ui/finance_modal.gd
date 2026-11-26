extends ColorRect
## Modal que detalla en formato tabla los ingresos mensuales, penalizaciones y costes de mantenimiento.

@export var summary_grid: GridContainer
@export var maintenance_grid: GridContainer
@export var net_label: Label
@export var close_button: Button


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(func() -> void: visible = false)


## Actualiza las cifras desde el motor de simulación en formato tabla y muestra el modal.
func open_breakdown(breakdown: Dictionary) -> void:
	var base_income: int = breakdown.get("base_income", 0)
	var ramp_bonus: int = breakdown.get("ramp_bonus", 0)
	var trust_mult: float = breakdown.get("trust_multiplier", 1.0)
	var gross: int = breakdown.get("gross_income", 0)
	var penalty: int = breakdown.get("penalty", 0)
	var effective: int = breakdown.get("effective_income", 0)
	var total_maint: int = breakdown.get("total_maintenance", 0)
	var net: int = breakdown.get("net_income", 0)
	var items: Array = breakdown.get("maintenance_items", [])

	if summary_grid:
		_clear_grid(summary_grid)
		_add_table_row(summary_grid, "Techo base + Rampa ($%d + $%d)" % [base_income, ramp_bonus], "$%d" % (base_income + ramp_bonus), Color(0.85, 0.9, 0.95))
		_add_table_row(summary_grid, "Factor Confianza Ciudadana", "×%.0f%%" % (trust_mult * 100.0), Color(0.75, 0.88, 0.98))
		_add_table_row(summary_grid, "Ingreso bruto mensual", "+$%d" % gross, Color(0.45, 0.92, 0.55))
		_add_table_row(summary_grid, "Penalizaciones comerciales", "-$%d" % penalty if penalty > 0 else "$0", Color(0.95, 0.45, 0.45) if penalty > 0 else Color(0.75, 0.78, 0.82))
		_add_table_row(summary_grid, "Ingreso efectivo (piso mín. $%d)" % GameBalance.MIN_BUDGET_INCOME_PER_TICK, "+$%d" % effective, Color(0.45, 0.92, 0.55))
		_add_table_row(summary_grid, "Mantenimiento total de políticas", "-$%d" % total_maint if total_maint > 0 else "$0", Color(0.95, 0.45, 0.45) if total_maint > 0 else Color(0.75, 0.78, 0.82))

	if maintenance_grid:
		_clear_grid(maintenance_grid)
		if items.is_empty():
			_add_table_row(maintenance_grid, "Sin políticas con mantenimiento activo", "$0", Color(0.7, 0.75, 0.8))
		else:
			for item: Dictionary in items:
				_add_table_row(maintenance_grid, str(item["title"]), "-$%d / mes" % item["maintenance"], Color(0.95, 0.6, 0.55))

	if net_label:
		var sign_str := "+" if net >= 0 else "-"
		net_label.text = "Balance Neto Mensual: %s$%d / mes" % [sign_str, absi(net)]
		if net > 0:
			net_label.modulate = Color(0.45, 0.92, 0.55)
		elif net < 0:
			net_label.modulate = Color(0.95, 0.4, 0.4)
		else:
			net_label.modulate = Color(0.9, 0.9, 0.9)

	visible = true


func _clear_grid(grid: GridContainer) -> void:
	for child: Node in grid.get_children():
		child.queue_free()


func _add_table_row(grid: GridContainer, concept: String, amount: String, amount_color: Color) -> void:
	var left_label := Label.new()
	left_label.text = concept
	left_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(left_label)

	var right_label := Label.new()
	right_label.text = amount
	right_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	right_label.modulate = amount_color
	grid.add_child(right_label)
