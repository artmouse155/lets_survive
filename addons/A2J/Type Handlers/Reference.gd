class_name A2JReferenceTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'"references" in ruleset should be structured as follows: Dictionary[String,Variant].',
		'Reference name should be a String.',
		'Could not load referenced resource at "~~".',
	]


## Should not be used.
func to_json(_value, _ruleset:Dictionary) -> void:
	pass


func from_json(json:Dictionary, ruleset:Dictionary) -> Variant:
	var named_references = ruleset.get('property_reference_values',{})
	if named_references is not Dictionary:
		report_error(0)
		return null

	var name = json.get('v','')
	if name is not String:
		report_error(1)
		return null
	name = name as String

	# Handle object reference.
	if name.begins_with('.i'):
		var ids_to_objects = A2J._process_data.get('ids_to_objects', {})
		if ids_to_objects is Dictionary:
			var id:String = name.split('.i')[1]
			return ids_to_objects.get(id, '_A2J_unresolved_reference')
	# Handle external resource reference.
	elif name.begins_with('.res:'):
		var path:String = name.replace('.res:','')
		var resource = load(path)
		if resource == null:
			report_error(2, path)
		return resource

	return named_references.get(name, null)
