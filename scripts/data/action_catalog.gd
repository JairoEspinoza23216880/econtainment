class_name ActionCatalog
extends RefCounted
## Catálogo extensible que descubre y almacena recursos ActionData desde res://resources/actions/.

const ActionDataClass = preload("res://scripts/data/action_data.gd")
const ACTIONS_DIR: String = "res://resources/actions"

var _actions_by_id: Dictionary = {}
var _ordered_ids: Array[StringName] = []


## Carga todos los archivos .tres válidos dentro del directorio de acciones.
func load_from_directory(directory_path: String = ACTIONS_DIR) -> void:
	_actions_by_id.clear()
	_ordered_ids.clear()

	if not DirAccess.dir_exists_absolute(directory_path):
		return

	_scan_directory(directory_path)


## Registra manualmente una acción (útil para pruebas o contenido generado en tiempo de ejecución).
func register_action(action: ActionDataClass) -> void:
	if action == null or action.id == &"":
		return
	if not _actions_by_id.has(action.id):
		_ordered_ids.append(action.id)
	_actions_by_id[action.id] = action


## Devuelve el recurso ActionData correspondiente al ID o null si no existe.
func get_action(action_id: StringName) -> ActionDataClass:
	return _actions_by_id.get(action_id, null)


## Devuelve todas las acciones registradas respetando su orden de carga.
func get_all_actions() -> Array[ActionDataClass]:
	var result: Array[ActionDataClass] = []
	for action_id: StringName in _ordered_ids:
		result.append(_actions_by_id[action_id])
	return result


## Devuelve todas las acciones pertenecientes a una rama específica.
func get_actions_by_branch(branch: GameBalance.BranchType) -> Array[ActionDataClass]:
	var result: Array[ActionDataClass] = []
	for action_id: StringName in _ordered_ids:
		var action: ActionDataClass = _actions_by_id[action_id]
		if action.branch == branch:
			result.append(action)
	return result


func _scan_directory(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not file_name.begins_with("."):
			var full_path := path.path_join(file_name)
			if dir.current_is_dir():
				_scan_directory(full_path)
			elif file_name.ends_with(".tres"):
				var resource := ResourceLoader.load(full_path)
				if resource is ActionDataClass:
					register_action(resource)
		file_name = dir.get_next()
	dir.list_dir_end()
