extends ColorRect
## Menú overlay de pausa (Reanudar o Salir al Menú Principal).

signal resumed
signal quit_to_menu_requested

@export var resume_button: Button
@export var quit_button: Button


func _ready() -> void:
	if resume_button:
		resume_button.pressed.connect(func() -> void: resumed.emit())
	if quit_button:
		quit_button.pressed.connect(func() -> void: quit_to_menu_requested.emit())
