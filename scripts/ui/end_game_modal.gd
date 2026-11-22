extends ColorRect
## Modal de fin de partida que muestra el resultado (Victoria o Derrota) y estadísticas.

signal retry_requested
signal main_menu_requested

@export var title_label: Label
@export var description_label: Label
@export var stats_label: Label
@export var retry_button: Button
@export var menu_button: Button


func _ready() -> void:
	if retry_button:
		retry_button.pressed.connect(func() -> void: retry_requested.emit())
	if menu_button:
		menu_button.pressed.connect(func() -> void: main_menu_requested.emit())


## Configura los textos y muestra el modal según el resultado de la simulación.
func show_result(result: GameBalance.GameResult, ticks: int, health: float, trust: float) -> void:
	match result:
		GameBalance.GameResult.VICTORY:
			if title_label:
				title_label.text = "¡Ciudad Sustentable Regenerada!"
			if description_label:
				description_label.text = "Lograste equilibrar la economía circular, la regulación y la participación ciudadana."
		GameBalance.GameResult.DEFEAT_COLLAPSE:
			if title_label:
				title_label.text = "Colapso Ecológico"
			if description_label:
				description_label.text = "La contaminación saturó las zonas y destruyó la capacidad de regeneración."
		GameBalance.GameResult.DEFEAT_DISMISSAL:
			if title_label:
				title_label.text = "Destitución Ciudadana"
			if description_label:
				description_label.text = "Las protestas sociales y la pérdida de gobernabilidad detuvieron tu gestión."
		_:
			return

	if stats_label:
		stats_label.text = "Meses gestionados: %d  |  Salud Ambiental: %.0f%%  |  Confianza: %.0f%%" % [
			ticks,
			health,
			trust,
		]
	visible = true
