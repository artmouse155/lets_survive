## Handles serialization for various packed array types.
## [br][br][b]Types:[/b]
## [br]- PackedByteArray
## [br]- PackedInt32Array
## [br]- PackedInt64Array
## [br]- PackedFloat32Array
## [br]- PackedFloat64Array
## [br]- PackedColorArray
class_name A2JPackedArrayTypeHandler extends A2JTypeHandler

const special_types:PackedStringArray = ['PackedStringArray', 'PackedColorArray']


func _init() -> void:
	error_strings = [
		'Cannot convert invalid packed array to JSON.',
		'Cannot construct packed array from invalid JSON representation.',
	]


func to_json(value, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.t': type_string(typeof(value)),
		'v': null,
	}

	if value is PackedByteArray:
		result.v = value.hex_encode()

	elif value is PackedInt32Array or value is PackedInt64Array \
	or value is PackedFloat32Array or value is PackedFloat64Array \
	or value is PackedVector2Array or value is PackedVector3Array \
	or value is PackedVector4Array:
		result.v = value.to_byte_array().hex_encode()

	# Serialize packed color array to array of color hex codes.
	elif value is PackedColorArray:
		var serialized_colors:Array[String] = []
		for color:Color in value:
			serialized_colors.append(color.to_html(true))
		result.v = serialized_colors

	elif value is PackedStringArray:
		result.v = Array(value)

	# Throw error if not an expected type.
	else:
		report_error(0)
		return {}

	return result


func from_json(json:Dictionary, ruleset:Dictionary) -> Variant:
	var type = json.get('.t')
	if type is not String:
		report_error(1)
		return null
	var value = json.get('v')
	if (type in special_types && value is not Array) or (value is not String && type not in special_types):
		report_error(1)
		return null

	if type == 'PackedByteArray': return hex_to_bytes(value)
	elif type == 'PackedInt32Array': return hex_to_bytes(value).to_int32_array()
	elif type == 'PackedInt64Array': return hex_to_bytes(value).to_int64_array()
	elif type == 'PackedFloat32Array': return hex_to_bytes(value).to_float32_array()
	elif type == 'PackedFloat64Array': return hex_to_bytes(value).to_float64_array()
	elif type == 'PackedVector2Array': return hex_to_bytes(value).to_vector2_array()
	elif type == 'PackedVector3Array': return hex_to_bytes(value).to_vector3_array()
	elif type == 'PackedVector4Array': return hex_to_bytes(value).to_vector4_array()

	elif type == 'PackedColorArray':
		value = value as Array
		var colors:Array[Color] = []
		for item in value:
			if item is not String: continue
			colors.append(Color(item))
		return PackedColorArray(colors)

	elif type == 'PackedStringArray':
		value = value as Array
		if not A2JUtil.is_string_array(value):
			report_error(1)
			return null
		return PackedStringArray(value)

	# Throw error if no conditions match.
	else:
		report_error(1)
		return null


func hex_to_bytes(hex:String) -> PackedByteArray:
	var bytes := PackedByteArray()
	for i in range(0, hex.length(), 2):
		var byte = hex.substr(i,2).hex_to_int()
		bytes.append(byte)
	return bytes
