extends ColorRect
## Modal inicial dividido en secciones secuenciales para explicar el objetivo y mecánicas clave.

signal dismissed

@export var step_label: Label
@export var title_label: Label
@export var body_label: Label
@export var back_button: Button
@export var next_button: Button

const SECTIONS: Array[Dictionary] = [
	{
		"title": "1. Tu Misión",
		"body": "Eres el titular de la comisión ambiental metropolitana.\n\nTu objetivo es alcanzar 100% de Salud Ambiental manteniendo la Confianza Ciudadana por encima del 70%.\n\nSi la Salud Ambiental o la Confianza Ciudadana llegan a 0%, perderás la partida.",
	},
	{
		"title": "2. Las 3 Zonas y Derrames",
		"body": "La ciudad se divide en Zona Productiva, Zona Urbana y Reserva Biológica.\n\nSi una zona alcanza 50% o más de polución, derramará contaminantes hacia la Reserva y reducirá la Confianza Ciudadana.\n\nSi logras bajar una zona a estado Sano (≤ 20%), la Confianza aumentará cada mes.",
	},
	{
		"title": "3. Políticas y Finanzas",
		"body": "La partida inicia en pausa.\n\nAbre «Acciones» para activar o derogar políticas (el reloj se pausará allí para que leas con calma) y revisa «Finanzas» en la barra inferior para vigilar el coste de mantenimiento mensual.\n\nPulsa «Reanudar» cuando estés listo para iniciar.",
	},
]

var _current_index: int = 0


func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
	visibility_changed.connect(_on_visibility_changed)
	_refresh_section()


func _on_visibility_changed() -> void:
	if visible:
		_current_index = 0
		_refresh_section()


func _refresh_section() -> void:
	if SECTIONS.is_empty():
		return
	var section: Dictionary = SECTIONS[_current_index]
	if step_label:
		step_label.text = "Guía rápida (%d / %d)" % [_current_index + 1, SECTIONS.size()]
	if title_label:
		title_label.text = section["title"]
	if body_label:
		body_label.text = section["body"]
	if back_button:
		back_button.disabled = _current_index == 0
	if next_button:
		next_button.text = "¡Entendido!" if _current_index == SECTIONS.size() - 1 else "Siguiente"


func _on_back_pressed() -> void:
	if _current_index > 0:
		_current_index -= 1
		_refresh_section()


func _on_next_pressed() -> void:
	if _current_index < SECTIONS.size() - 1:
		_current_index += 1
		_refresh_section()
	else:
		visible = false
		GameManager.has_seen_welcome = true
		dismissed.emit()
