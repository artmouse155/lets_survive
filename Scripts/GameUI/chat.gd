class_name Chat extends Control

signal send_peers_msg(msg: String)

const SCROLL_MAX : int = 999999999
const CHAT_MESSAGE_PACKED : PackedScene = preload("uid://c860wmol3yjcq")

const MESSAGE_DURATION : float = 5.0
const FADE_DURATION : float = 0.5

@export var input : LineEdit
@export var msg_box : BoxContainer
@export var scroll : ScrollContainer
@export var disappearing_messages_container : BoxContainer
#@export var disappearing_messages_scroll_container : ScrollContainer

func _on_visibility_changed() -> void:
	input.clear()
	if visible:
		input.grab_focus.call_deferred()
		scroll.set_deferred("scroll_vertical",SCROLL_MAX)
	disappearing_messages_container.visible = !visible

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text != "":
		input.clear()
		send_peers_msg.emit(new_text)


@rpc("authority", "call_local", "reliable")
func send_system_msg(msg : String) -> void:
	await _print_msg(msg)


@rpc("authority", "call_local", "reliable")
func send_error(msg : String) -> void:
	await _print_msg("[color=#ff5f5f]Error: %s[/color]" % _escape_bbcode(msg))


@rpc("authority", "call_local", "reliable")
func send_player_msg(player_name : String, msg : String) -> void:
	await _print_msg("<%s> %s" % [player_name, _escape_bbcode(msg)])


@rpc("authority", "call_local", "reliable")
func send_join_game_msg(player_name : String) -> void:
	await _print_msg("[color=yellow]%s joined the game[/color]" % _escape_bbcode(player_name))


@rpc("authority", "call_local", "reliable")
func send_leave_game_msg(player_name : String) -> void:
	await _print_msg("[color=yellow]%s left the game[/color]" % _escape_bbcode(player_name))


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
		_scroll_to_bottom()
		input.grab_focus.call_deferred()
	var disappearing_message_node : RichTextLabel = CHAT_MESSAGE_PACKED.instantiate()
	disappearing_message_node.text = message
	disappearing_messages_container.add_child(disappearing_message_node)
	var tween := create_tween()
	tween.tween_interval(MESSAGE_DURATION)
	tween.tween_property(disappearing_message_node, "modulate:a", 0.0, FADE_DURATION)
	tween.tween_callback(disappearing_message_node.queue_free)
	#disappearing_messages_scroll_container.set_deferred("scroll_vertical",SCROLL_MAX)

func clear_chat() -> void:
	for child in msg_box.get_children():
		child.queue_free()
	for child in disappearing_messages_container.get_children():
		child.queue_free()

func _scroll_to_bottom() -> void:
	scroll.set_deferred("scroll_vertical",SCROLL_MAX)

## Source: [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#handling-user-input-safely]Godot Docs[/url]
static func _escape_bbcode(bbcode_text: String) -> String:
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")
