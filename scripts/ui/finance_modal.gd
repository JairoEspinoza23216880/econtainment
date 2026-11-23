extends ColorRect
## Modal que detalla los ingresos mensuales, penalizaciones y costes de mantenimiento activos.

@export var summary_label: Label
@export var maintenance_list_label: Label
@export var net_label: Label
@export var close_button: Button


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(func() -> void: visible = false)


## Actualiza las cifras desde el motor de simulación y muestra el modal.
func open_breakdown(breakdown: Dictionary) -> void:
	var gross: int = breakdown.get("gross_income", 0)
	var penalty: int = breakdown.get("penalty", 0)
	var effective: int = breakdown.get("effective_income", 0)
	var total_maint: int = breakdown.get("total_maintenance", 0)
	var net: int = breakdown.get("net_income", 0)
	var items: Array = breakdown.get("maintenance_items", [])

	if summary_label:
		summary_label.text = (
			"Ingreso bruto por recaudación: +$%d / mes\n"
			+ "Penalizaciones comerciales (Boicot): -$%d / mes\n"
			+ "Ingreso efectivo: +$%d / mes\n"
			+ "Mantenimiento total de políticas: -$%d / mes"
		) % [gross, penalty, effective, total_maint]

	if maintenance_list_label:
		if items.is_empty():
			maintenance_list_label.text = "Sin políticas con coste de mantenimiento activo."
		else:
			var lines: PackedStringArray = []
			for item: Dictionary in items:
				lines.append("• %s: -$%d / mes" % [item["title"], item["maintenance"]])
			maintenance_list_label.text = "\n".join(lines)

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
