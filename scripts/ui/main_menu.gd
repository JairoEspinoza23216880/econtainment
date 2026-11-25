extends Control
## Controlador del Menú Principal (título arriba a la izquierda, Jugar, Jugar Tutorial y Salir).

const GAME_SCENE_PATH: String = "res://scenes/game/game_screen.tscn"

@export var play_button: Button
@export var tutorial_button: Button
@export var quit_button: Button


func _ready() -> void:
	# Conectamos las señales de los botones por código usando referencias @export
	if play_button:
		play_button.pressed.connect(_on_play_pressed)
	if tutorial_button:
		tutorial_button.pressed.connect(_on_tutorial_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	# En plataformas web ocultamos el botón Salir ya que el navegador controla la pestaña
	if OS.has_feature("web") and quit_button:
		quit_button.visible = false


func _on_play_pressed() -> void:
	GameManager.start_new_game(false)
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_tutorial_pressed() -> void:
	GameManager.start_new_game(true)
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


func _on_quit_pressed() -> void:
	GameManager.quit_game()
