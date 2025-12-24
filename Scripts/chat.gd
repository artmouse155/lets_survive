class_name Chat extends Control

const SCROLL_MAX : int = 999999999
const CHAT_MESSAGE_PACKED : PackedScene = preload("uid://c860wmol3yjcq")

@export var input : LineEdit
@export var msg_box : BoxContainer
@export var scroll : ScrollContainer

func _on_visibility_changed() -> void:
	input.clear()
	if visible:
		input.grab_focus.call_deferred()
		scroll.set_deferred("scroll_vertical",SCROLL_MAX)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text != "":
		input.clear()
		send_player_msg(new_text)


func send_system_msg(msg : String) -> void:
	_print_msg(msg)


func send_player_msg(msg : String) -> void:
	_print_msg("<%s> %s" % ["Chase", escape_bbcode(msg)])


func send_join_game_msg(player_name : String) -> void:
	_print_msg("[color=yellow]%s joined the game[/color]" % escape_bbcode(player_name))


func send_leave_game_msg(player_name : String) -> void:
	_print_msg("[color=yellow]%s left the game[/color]" % escape_bbcode(player_name))


func _print_msg(message : String) -> void:
	var current_scroll : float = scroll.get_v_scroll_bar().value
	var max_scroll : float = scroll.get_v_scroll_bar().max_value
	var page_size : float = scroll.get_v_scroll_bar().page
	#print("Current scroll: %s\tMax scroll: %s\tPage size: %s" % [current_scroll, max_scroll, page_size])
	var on_bottom := is_equal_approx(current_scroll + page_size, max_scroll)
	var message_node : RichTextLabel = CHAT_MESSAGE_PACKED.instantiate()
	message_node.text = message
	msg_box.add_child(message_node)
	if on_bottom:
		await get_tree().process_frame
		#scroll.ensure_control_visible(message_node)
		scroll_to_bottom()
		input.grab_focus.call_deferred()

func scroll_to_bottom():
	scroll.set_deferred("scroll_vertical",SCROLL_MAX)

static func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")
