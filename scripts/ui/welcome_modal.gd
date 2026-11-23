extends ColorRect
## Modal inicial breve que explica el objetivo y las mecánicas básicas antes de reanudar el reloj.

signal dismissed

@export var close_button: Button


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_pressed)


func _on_close_pressed() -> void:
	visible = false
	GameManager.has_seen_welcome = true
	dismissed.emit()
