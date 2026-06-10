## Handles serialization for the Object type.
class_name A2JObjectTypeHandler extends A2JTypeHandler

const script_property_type_details:Dictionary[String,Dictionary] = {
	'script': {
		'class_name': &'Script',
		'type': 24,
		'hint': 17,
		'hint_string': 'Script',
	},
}


func _init() -> void:
	error_strings = [
		'Class "~~" is not defined in registry.',
		'"property_exclusions" in ruleset should be structured as follows: Array[String].',
		'"property_references" in ruleset should be structured as follows: Dictionary[String,String].',
		'"instantiator_function" in ruleset should be structured as follows: Callable(registered_object:Object, object_class:String, args:Array=[]) -> Object.',
		'"instantiator_arguments" in rulset should be structured as follows: Dictionary[String,Array].',
		'"property_inclusions" in ruleset should be structured as follows: Array[String].',
		'Cannot convert from an invalid JSON representation.',
	]
	init_data = {
		'ids_to_objects': {},
	}


func to_json(object:Object, ruleset:Dictionary) -> Variant:
	var object_class := A2JUtil.get_class_name(object)

	# Get & check registered object equivalent.
	var registered_object = A2J.object_registry.get(object_class, null)
	if registered_object == null:
		report_error(0, object_class)
		return null
	registered_object = registered_object as Object
	# Get default object to compare properties with.
	var default_object:Object = _get_default_object(registered_object, object_class, ruleset)

	# If object is an external resource, return a reference to it.
	if ruleset.get('automatic_resource_references') == true && object is Resource:
		if not object.resource_path.is_empty() && not object.resource_path.contains('::'):
			return _make_reference('.res:%s' % object.resource_path)

	# If object has been serialized before, return a reference to it.
	var ids_to_objects:Dictionary = A2J._process_data.ids_to_objects
	var id = ids_to_objects.find_key(object)
	if id != null:
		return _make_reference('.i'+str(id))
	# If not, add to object stack & update index.
	else:
		id = ids_to_objects.keys().size()
		A2J._process_data.ids_to_objects.set(id, object)

	# Set up result.
	var result:Dictionary[String,Variant] = {
		'.t': 'Obj:%s:%s' % [id, object_class],  # Pack class name & ID into type.
	}

	# Get exceptions from ruleset.
	var properties_to_reference:Dictionary[String,String] = ruleset.get('property_references', Dictionary({}, TYPE_STRING, '', null, TYPE_STRING, '', null))
	var properties_to_exclude:Array = ruleset.get('property_exclusions', [])
	var properties_to_include:Array = ruleset.get('property_inclusions', [])
	var props_to_include_temp:Array = ruleset.get('property_inclusions', [])
	var do_properties_to_include = not props_to_include_temp.is_empty()

	# Convert all properties.
	for property in object.get_property_list():
		if _validate_object_property(result, property.name, properties_to_reference, properties_to_exclude, properties_to_include, do_properties_to_include, ruleset) == false: continue
		# Exclude null values.
		var property_value = object.get(property.name)
		if property_value == null: continue
		# Exclude values that are the same as default values.
		if ruleset.get('exclude_default_properties'):
			if property_value == default_object.get(property.name): continue

		A2J._tree_position.append(property.name)
		# Convert value.
		var new_value = A2J._to_json(property_value)
		# Don't store null values.
		if new_value == null:
			A2J._tree_position.pop_back()
			continue
		# Set new value.
		result.set(property.name, new_value)
		A2J._tree_position.pop_back()

	return result


func from_json(json:Dictionary, ruleset:Dictionary) -> Object:
	var object_class:StringName = json.get('.t', '')
	var split_object_class = object_class.split(':')
	# Throw error if invalid number of splits.
	if split_object_class.size() != 3:
		report_error(6)
		return Object.new()
	# Set object class & id.
	object_class = split_object_class[2]
	var id = split_object_class[1]
	
	# Get & check registered object equivalent.
	var registered_object = A2J.object_registry.get(object_class, null)
	if registered_object == null:
		report_error(0)
	registered_object = registered_object as Object

	# Add result object to "ids_to_objects" for use in references.
	var result := _get_default_object(registered_object, object_class, ruleset)
	A2J._process_data.ids_to_objects.set(str(id), result)
	# Get rules.
	var properties_to_reference:Dictionary[String,String] = ruleset.get('property_references', Dictionary({}, TYPE_STRING, '', null, TYPE_STRING, '', null))
	var properties_to_exclude:Array = ruleset.get('property_exclusions', [])
	var properties_to_include:Array = ruleset.get('property_inclusions', [])
	var do_properties_to_include = not ruleset.get('property_inclusions',[]).is_empty()
	var has_script:bool = false
	# Sort keys to prioritize script property.
	var keys = json.keys()
	for item in ['script']:
		if keys.has(item):
			has_script = true
			keys.erase(item)
			keys.insert(0, item)
	# Dont get property type details before script is applied.
	var all_property_type_details:Dictionary[String,Dictionary] = _get_all_property_type_details(result) if not has_script else script_property_type_details

	# Convert all values in the dictionary.
	for key in keys:
		if _validate_object_property(result, key, {}, properties_to_exclude, properties_to_include, do_properties_to_include, ruleset) == false: continue
		A2J._tree_position.append(key)
		var value = json[key]
		var property_type_details:Dictionary = all_property_type_details.get(key, {})
		var new_value = A2J._from_json(value, property_type_details)
		# Pass unresolved reference off to be resolved ater all objects are serialized & present in the object stack.
		if new_value is String && new_value == '_A2J_unresolved_reference':
			A2J._process_next_pass_functions.append(_resolve_reference.bind(result, key, value))
			A2J._tree_position.pop_back()
			continue
		# Set value as metadata.
		if key.begins_with('metadata/'):
			result.set_meta(key.replace('metadata/',''), new_value)
		# Set value
		else: result.set(key, new_value)
		A2J._tree_position.pop_back()

		# Update property type details after script has been applied to the object.
		if key == 'script':
			all_property_type_details = _get_all_property_type_details(result)

	return result


func _validate_object_property(result, name:String, properties_to_reference:Dictionary, properties_to_exclude:Array, properties_to_include:Array, do_properties_to_include:bool, ruleset:Dictionary) -> bool:
	if name in properties_to_exclude: return false
	if ruleset.get('exclude_private_properties'):
		if name.begins_with('_') or name.begins_with('metadata/_'): return false
	if do_properties_to_include && name not in properties_to_include: return false
	# If reference is on "properties_to_reference" list. Set a reference of the property.
	if name in properties_to_reference:
		var reference_name = properties_to_reference[name]
		result.set(name, _make_reference(reference_name))
		return false
	return true


func _resolve_reference(value, result, ruleset:Dictionary, object:Object, property:String, reference_to_resolve) -> Variant:
	var resolved_reference = A2J._from_json(reference_to_resolve)
	if resolved_reference is String && resolved_reference == '_A2J_unresolved_reference': resolved_reference = null
	
	# Set value as metadata.
	if property.begins_with('metadata/'):
		object.set_meta(property.replace('metadata/',''), resolved_reference)
	# Set value
	else: object.set(property, resolved_reference)

	return result


func _make_reference(name:String) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.t': 'A2JRef',
		'v': name,
	}
	return result


## Get the default object to compare properties to.
func _get_default_object(registered_object:Object, object_class:StringName, ruleset:Dictionary) -> Object:
	var instantiator_function = ruleset.get('instantiator_function', A2J._default_instantiator_function)
	var instantiator_arguments = ruleset.get('instantiator_arguments', {})
	if instantiator_function is not Callable:
		instantiator_function = A2J._default_instantiator_function
		report_error(3)
	# Correct instantiator arguments to be dictionary if it isn't.
	if instantiator_arguments is not Dictionary:
		instantiator_arguments = {}
		report_error(4)
	# Get arguments.
	var args = instantiator_arguments.get(object_class)
	# If no instantiation arguments provided, call with no arguments.
	if args is not Array or args.size() == 0:
		return instantiator_function.call(registered_object, object_class)
	# Otherwise, call with arguments.
	else:
		return instantiator_function.call(registered_object, object_class, args)


func _get_all_property_type_details(object:Object) -> Dictionary[String,Dictionary]:
	var properties:Dictionary[String,Dictionary] = {}
	var property_list := object.get_property_list()
	for item in property_list:
		properties.set(item.name, {
			'class_name': item.class_name,
			'type': item.type,
			'hint_string': item.hint_string,
		})
	return properties
