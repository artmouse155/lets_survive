class_name Serializer extends RefCounted

const USER_DIR = "user://"
const WORLD_SUB_DIR = "world_saves"
const FILE_TYPE = ".json"

var directory : String

enum ListType { FILES, DIRECTORIES }

func _init(
	p_directory : String,
	) -> void:
	directory = p_directory
	A2J.object_registry.merge({
 		'PlayerSave': PlayerSave,
	})
	var error := DirAccess.make_dir_recursive_absolute(p_directory)
	if error != OK:
		push_error(error_string(error))

## Deserialize the given [String].
func _des(s : String) -> Variant:
	var file := FileAccess.open("%s/%s%s" % [directory,s,FILE_TYPE], FileAccess.READ)
	if file:
		var obj_json := file.get_as_text()
		var json := JSON.new()
		var error := json.parse(obj_json)
		if error != OK:
			push_error("Parsing save JSON %s failed " % s)
			return null
		var obj : Variant = A2J.from_json(json.data)
		print("Deserialized %s as %s" % [s, type_string(typeof(obj))])
		if obj:
			return obj
		push_error("Deserializing %s failed" % s)
		return null
	push_warning("Error loading %s: %s" % [s, error_string(FileAccess.get_open_error())])
	return null

## Serialize the given [Variant].
func _ser(s: String, o : Variant) -> void:
	var obj_json : Variant = A2J.to_json(o)
	if obj_json:
		var file := FileAccess.open("%s/%s%s" % [directory,s,FILE_TYPE], FileAccess.WRITE)
		if file:
			var json := JSON.stringify(obj_json)
			if file.store_string(str(json)):
				return
			push_error("Could not store JSON for %s" % s)
			return
		push_error(error_string(FileAccess.get_open_error()))
		return
	push_error("Serializing %s failed" % str(o))

## Lists either files or sub-directories in the given directory.
func _list(list_type : ListType = ListType.FILES) -> PackedStringArray:
	var dir := DirAccess.open(directory)
	match list_type:
		ListType.FILES:
			return dir.get_files() 
		ListType.DIRECTORIES:
			return dir.get_directories()
	return []
