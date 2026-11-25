class_name ActionCatalog
extends RefCounted
## Catálogo extensible que descubre y almacena recursos ActionData desde res://resources/actions/.

const ActionDataClass = preload("res://scripts/data/action_data.gd")
const ACTIONS_DIR: String = "res://resources/actions"

var _actions_by_id: Dictionary = {}
var _ordered_ids: Array[StringName] = []


## Carga todos los archivos .tres válidos dentro del directorio de acciones (compatible con .pck exportado).
func load_from_directory(directory_path: String = ACTIONS_DIR) -> void:
	_actions_by_id.clear()
	_ordered_ids.clear()
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
	# ResourceLoader.list_directory funciona tanto en editor como dentro del .pck exportado (Web/Android)
	var entries := ResourceLoader.list_directory(path)
	for entry: String in entries:
		if entry.ends_with("/"):
			var sub_dir := path.path_join(entry.trim_suffix("/"))
			_scan_directory(sub_dir)
		elif entry.ends_with(".tres"):
			var full_path := path.path_join(entry)
			var resource := ResourceLoader.load(full_path)
			if resource is ActionDataClass:
				register_action(resource)
