class_name SaveLoad extends Object

const NAMING_REGEX = "[a-zA-Z _\\d]{1,}"

const USER_DIR = "user://"
const GLOBAL_SAVE_DATA_NAME = "global_data"
const SAVE_SUFFIX = ".tres"

const PLAYER_SUB_DIR = "player_saves"
const PLAYER_SAVE_CLASS = "PlayerSave"


const WORLD_SUB_DIR = "world_saves"
const WORLD_SAVE_CLASS = "WorldSave"
const CHUNKS_FOLDER_NAME = "chunks"
const CHUNKS_SAVE_SUFFIX = ".tscn"

const MAX_NUM_SAVES = 5
#save filenames start with save_0, and go on numerically. if save_0 and save_2 exist, the next save created will be save_1.tres.

static func get_player_saves() -> Array[PlayerSave]:
	var output : Array[PlayerSave] = []
	for filename : String in get_filename_list(PLAYER_SUB_DIR):
		var save : PlayerSave = _load_res(PLAYER_SUB_DIR,filename,PLAYER_SAVE_CLASS) as PlayerSave
		output.append(save)
	return output


static func get_player_save(player_name : String) -> PlayerSave:
	var filename := "%s%s" % [player_name, SAVE_SUFFIX]
	return _load_res(PLAYER_SUB_DIR, filename, PLAYER_SAVE_CLASS) as PlayerSave
	

static func get_world_saves() -> Array[WorldSave]:
	var output : Array[WorldSave] = []
	for world_name : String in get_subdir_list(WORLD_SUB_DIR):
		var sub_dir := "%s/%s" % [WORLD_SUB_DIR, world_name]
		var save : WorldSave = _load_res(sub_dir,"%s%s" % [world_name, SAVE_SUFFIX],WORLD_SAVE_CLASS) as WorldSave
		output.append(save)
	return output

static func get_world_save(world_name : String) -> WorldSave:
	var filename := "%s%s" % [world_name, SAVE_SUFFIX]
	var sub_dir := "%s/%s" % [WORLD_SUB_DIR, world_name]
	return _load_res(sub_dir, filename, WORLD_SAVE_CLASS) as WorldSave

static func create_character(player_name : String, player_shirt_color : Color) -> void:
	var newSave := PlayerSave.new(player_name, player_shirt_color)
	_save_res(PLAYER_SUB_DIR, newSave, "%s%s" % [player_name, SAVE_SUFFIX])

static func create_world(world_name : String, world_seed : String) -> void:
	if world_seed == "":
		world_seed = str(randi())
	var newSave := WorldSave.new(world_name, world_seed)
	var sub_dir := "%s/%s" % [WORLD_SUB_DIR, world_name]
	ensure_sub_dir(sub_dir)
	ensure_sub_dir("%s/%s" % [sub_dir,CHUNKS_FOLDER_NAME])
	_save_res(sub_dir, newSave, "%s%s" % [world_name, SAVE_SUFFIX])

static func save_player(player_name : String, player_save : PlayerSave) -> void:
	_save_res(PLAYER_SUB_DIR, player_save, "%s%s" % [player_name, SAVE_SUFFIX])
	print("Saved player \"%s\"" % player_name)

static func save_world(world_name : String, world_save : WorldSave) -> void:
	var sub_dir := "%s/%s" % [WORLD_SUB_DIR, world_name]
	_save_res(sub_dir, world_save, "%s%s" % [world_name, SAVE_SUFFIX])
	print("Saved world \"%s\"" % world_name)

## __________________________________________________________

static func get_file_count(sub_dir : String) -> int:
	return len(get_filename_list(sub_dir))


static func delete(sub_dir: String, filename: String) -> void:
	var dir := DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if dir.file_exists(filename):
		dir.remove("%s%s/%s" % [USER_DIR, sub_dir, filename])
	else:
		push_error("Couldn't delete " + filename + ". File not found.")


static func get_filename_list(sub_dir : String) -> Array[String]:
	ensure_sub_dir(sub_dir)
	var dir := DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	var output : Array[String] = []
	
	var regex := RegEx.new()
	regex.compile("^%s\\%s$" % [NAMING_REGEX, SAVE_SUFFIX])
	
	for filename : String in dir.get_files():
		if regex.search(filename):
			output.append(filename)
	return output

static func get_subdir_list(sub_dir : String) -> Array[String]:
	ensure_sub_dir(sub_dir)
	var dir := DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	var output : Array[String] = []
	
	var regex := RegEx.new()
	regex.compile("^%s$" % [NAMING_REGEX])
	
	for dirname : String in dir.get_directories():
		if regex.search(dirname):
			output.append(dirname)
	return output

# "test.tres".match("[a-zA-Z _\\d]{1,}.tres")
#makes sure the filestructure we want exists
static func ensure_sub_dir(sub_dir : String) -> bool:
	var dir := DirAccess.open(USER_DIR)
	if !dir.dir_exists(sub_dir):
		dir.make_dir(sub_dir)
	dir = null
	return true


static func ensure_global() -> bool:
	var dir := DirAccess.open(USER_DIR)
	if !dir.file_exists(GLOBAL_SAVE_DATA_NAME + SAVE_SUFFIX):
		dir = null
		pass
	return true


static func _save_res(sub_dir : String, data: Resource, filename : String = "") -> void:
	ensure_sub_dir(sub_dir)
	var dir := DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if (!dir.file_exists(filename)) and (len(get_filename_list(sub_dir)) >= MAX_NUM_SAVES):
		push_error("NO MORE ROOM FOR SAVES")
		return
	ResourceSaver.save(data, "%s%s/%s" % [USER_DIR, sub_dir, filename])


static func _load_res(sub_dir : String, filename : String = "", type_hint : String = "Resource") -> Resource:
	ensure_sub_dir(sub_dir)
	var dir := DirAccess.open("%s%s/" % [USER_DIR, sub_dir])
	if dir.file_exists(filename):
		var resource := ResourceLoader.load("%s%s/%s" % [USER_DIR, sub_dir, filename], type_hint) as Resource
		if !resource:
			push_error("Couldn't parse %s" % filename)
			return null
		#HACK: This is because GDScript be funky...
		if (
			(type_hint == PLAYER_SAVE_CLASS) and !(resource is PlayerSave) or
			(type_hint == WORLD_SAVE_CLASS) and !(resource is WorldSave)
		):
			push_error("Couldn't parse %s as type \"%s\"" % [filename, type_hint])
			return null
		return resource
	else:
		push_error("Couldn't find " + filename)
		return null

static func load_chunk(world_name: String, coords: Vector2i) -> Chunk:
	var dir := "%s%s/%s/%s" % [USER_DIR, WORLD_SUB_DIR, world_name, CHUNKS_FOLDER_NAME]
	var dir_access := DirAccess.open(dir)
	var filename := "%d_%d%s" % [coords.x, coords.y, CHUNKS_SAVE_SUFFIX]
	if dir_access.file_exists(filename):
		var chunk_packed := ResourceLoader.load("%s/%s" % [dir, filename], "PackedScene") as PackedScene
		if !chunk_packed or !(chunk_packed is PackedScene):
			push_error("Couldn't parse %s" % filename)
			return null
		var chunk : Chunk = chunk_packed.instantiate() as Chunk
		return chunk
	return null
