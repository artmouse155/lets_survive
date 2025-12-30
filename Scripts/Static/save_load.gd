class_name SaveLoad extends Object

const USER_DIR = "user://"
const GLOBAL_SAVE_DATA_NAME = "global_data"
const SAVE_SUFFIX = ".tres"

const PLAYER_SUB_DIR = "player_saves"
const PLAYER_SAVE_PREFIX = "player_"

const WORLD_SUB_DIR = "world_saves"
const WORLD_SAVE_PREFIX = "world_"

const MAX_NUM_SAVES = 5
#save filenames start with save_0, and go on numerically. if save_0 and save_2 exist, the next save created will be save_1.tres.

static func get_player_saves() -> Array[PlayerSave]:
	var output : Array[PlayerSave] = []
	for i : int in get_file_count(PLAYER_SUB_DIR):
		var save := get_player_save(i)
		output.append(save)
	return output
	## Commenting this out. This code would DELETE saves that it couldn't parse correctly. Yuck.
	#var output : Array[PlayerSave] = []
	#var filenames : Array[String] = get_filename_list(PLAYER_SUB_DIR)
	#var invalid : Array[String] = []
	#for i : int in get_file_count(PLAYER_SUB_DIR):
		#var player_save := get_player_save(i)
		#if player_save:
			#output.append(player_save)
		#else:
			#invalid.append(filenames[i])
	#for filename : String in invalid:
		#delete(PLAYER_SUB_DIR,filename)
	#return output

static func get_player_save(index : int) -> PlayerSave:
	var filename := get_filename_list(PLAYER_SUB_DIR)[index]
	var resource : Resource = load_res(PLAYER_SUB_DIR,filename,"PlayerSave")
	if is_instance_of(resource,PlayerSave):
		return resource
	print("Couldn't parse %s" % filename)
	return null

static func get_world_saves() -> Array[WorldSave]:
	var output : Array[WorldSave] = []
	for i : int in get_file_count(WORLD_SUB_DIR):
		var save := get_world_save(i)
		output.append(save)
	return output

static func get_world_save(index : int) -> WorldSave:
	var filename := get_filename_list(WORLD_SUB_DIR)[index]
	var resource : Resource = load_res(WORLD_SUB_DIR,filename,"WorldSave")
	if is_instance_of(resource,WorldSave):
		return resource
	print("Couldn't parse %s" % filename)
	return null

static func create_character(player_name : String, player_shirt_color : Color) -> void:
	var newSave := PlayerSave.new(player_name,player_shirt_color)
	save_res(PLAYER_SUB_DIR,PLAYER_SAVE_PREFIX,newSave)

static func create_world(world_name : String, world_seed : String) -> void:
	if world_seed == "":
		world_seed = str(randi())
	var newSave := WorldSave.new(world_name, world_seed)
	save_res(WORLD_SUB_DIR,WORLD_SAVE_PREFIX,newSave)

## __________________________________________________________


static func get_file_count(sub_dir : String) -> int:
	return len(get_filename_list(sub_dir))

# If filename is null or empty, we create a new file
static func save_res(sub_dir : String, prefix : String, data: Resource, filename: String = "") -> void:
	ensure_sub_dir(sub_dir)
	var dir = DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if dir.file_exists(filename):
		ResourceSaver.save(data, "%s%s/%s" % [USER_DIR, sub_dir, filename])
	else:
		if (!filename or filename == ""):
			_new_file_save(sub_dir, prefix, data)
		else:
			print("Couldn't save to " + filename)


static func _new_file_save(sub_dir: String, prefix : String, data: Resource) -> String:
	var save_names := get_filename_list(sub_dir)
	var valid_name: bool = false
	var i = 0
	var save_name: String
	while !valid_name:
		var temp_filename = "%s%s%s" % [prefix, str(i), SAVE_SUFFIX]
		if !(temp_filename in save_names):
			save_name = temp_filename
			valid_name = true
		i += 1
		if i == (MAX_NUM_SAVES + 1):
			print("NO MORE ROOM FOR SAVES")
			return ""
	ResourceSaver.save(data, "%s%s/%s" % [USER_DIR, sub_dir, save_name])
	return save_name


static func load_res(sub_dir : String, filename : String = "", type_hint : String = "Resource"):
	ensure_sub_dir(sub_dir)
	var dir = DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if dir.file_exists(filename):
		return ResourceLoader.load("%s%s/%s" % [USER_DIR, sub_dir, filename], type_hint)
	else:
		print("Couldn't find " + filename)
		return null


static func delete(sub_dir: String, filename: String):
	var dir = DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if dir.file_exists(filename):
		dir.remove("%s%s/%s" % [USER_DIR, sub_dir, filename])
	else:
		print("Couldn't delete " + filename + ". File not found.")
		return null


static func get_filename_list(sub_dir : String) -> Array[String]:
	ensure_sub_dir(sub_dir)
	var dir = DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	var output : Array[String] = []
	for filename : String in dir.get_files():
		output.append(filename)
	return output

#makes sure the filestructure we want exists
static func ensure_sub_dir(sub_dir : String) -> bool:
	var dir := DirAccess.open(USER_DIR)
	if !dir.dir_exists(sub_dir):
		dir.make_dir(sub_dir)
	dir = null
	return true


static func ensure_global() -> bool:
	var dir = DirAccess.open(USER_DIR)
	if !dir.file_exists(GLOBAL_SAVE_DATA_NAME + SAVE_SUFFIX):
		dir = null
		pass
	return true
