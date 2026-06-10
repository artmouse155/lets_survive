## Handles serialization for Vector2(i), Vector3(i), & Vector4(i) types.
class_name A2JVectorTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'Cannot convert non-vector value to JSON.',
		'Cannot construct vector from invalid JSON representation.',
		'Vectors should only contain int/float values.',
	]


func to_json(vector, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.t': 'Vector',
		'v': [],
	}
	var is_float:bool = true
	# Vector2.
	if vector is Vector2:
		result.v = [vector.x, vector.y]
	elif vector is Vector2i:
		result.v = [vector.x, vector.y]
		is_float = false
	# Vector3.
	elif vector is Vector3:
		result.v = [vector.x, vector.y, vector.z]
	elif vector is Vector3i:
		result.v = [vector.x, vector.y, vector.z]
		is_float = false
	# Vector4.
	elif vector is Vector4:
		result.v = [vector.x, vector.y, vector.z, vector.w]
	elif vector is Vector4i:
		result.v = [vector.x, vector.y, vector.z, vector.w]
		is_float = false

	# Throw error if not a vector.
	else:
		report_error(0)
		return {}

	if not is_float: result['.t'] += 'I' # Set type to "VectorI" if it doesn't contain floats.
	return result


func from_json(json:Dictionary, ruleset:Dictionary) -> Variant:
	var value = json.get('v')
	var is_float:bool = not json.get('.t').ends_with('I')
	# Throw error if "value" is not an Array.
	if value is not Array:
		report_error(1)
		return null
	# Re-type value.
	value = value as Array
	
	# Check & throw error if "value" contains anything not a number.
	if not A2JUtil.is_number_array(value):
		report_error(2)
		return null

	var count:int = value.size()
	# Float vectors.
	if is_float: match count:
		2: return Vector2(value[0], value[1])
		3: return Vector3(value[0], value[1], value[2])
		4: return Vector4(value[0], value[1], value[2], value[3])
	# Integer-only vectors.
	else: match count:
		2: return Vector2i(int(value[0]), int(value[1]))
		3: return Vector3i(int(value[0]), int(value[1]), int(value[2]))
		4: return Vector4i(int(value[0]), int(value[1]), int(value[2]), int(value[3]))

	# Throw error if no conditions match
	report_error(1)
	return null
