class_name ConnectionBus extends Node

## A dict that keeps track of players in the game. Only used by the host.
var players: Dictionary[int, PlayerConnection] = {}

const SERVER_PEER_ID = 1
const MAX_CLIENTS = 10
const CONNECTION_TIMEOUT := 10.0

@export var game_ui : GameUI

@export var chat: Chat
@onready var timeout_tween: Tween
@export var host_lan_button: Button

@export var load_screen : Control
@export var load_screen_text : RichTextLabel
@export var load_screen_button : Button

#region Connection
func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	# Clients Only
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_networking_ui_join(host: String, port: String) -> void:
	load_screen_button.show()
	if (int(port) < 1 or int(port) > 65535):
		load_screen_text.text = "the remote port number must be between 1 and 65535 (inclusive)."
		return
	load_screen_text.text = "Creating client..."
	await get_tree().process_frame
	# Create client.
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(host, int(port))
	if error != OK:
		load_screen_text.text = "failed to create client."
		return
	load_screen_text.text = "Client created successfully on port %s" % port
	load_screen_text.text = "Attempting to connect to server..."
	multiplayer.multiplayer_peer = peer
	if timeout_tween:
		timeout_tween.kill()
	timeout_tween = create_tween()
	timeout_tween.tween_interval(CONNECTION_TIMEOUT)
	timeout_tween.tween_callback(_on_connection_timeout)
	
func _on_connection_timeout() -> void:
	_end_connection()
	load_screen_text.text = "Error\nConnection timed out"
	load_screen_button.show()

func _on_networking_ui_host(port: String) -> void:
	if (int(port) < 1 or int(port) > 65535):
		chat.send_error("the remote port number must be between 1 and 65535 (inclusive).")
		return
	await chat.send_system_msg("Creating server...")
	await get_tree().process_frame
	# Create server.
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(int(port), MAX_CLIENTS)
	if error != OK:
		chat.send_error("failed to create server.")
		return
	chat.send_system_msg("Server created successfully!")
	var ip := _get_lan_ip()
	if (ip != ""):
		chat.send_system_msg("Hosted on %s:%d" % [ip, int(port)])
	else:
		chat.send_system_msg("Hosted on unknown IP address. Use the terminal to find an IPv4 address.")
		chat.send_system_msg("Hosting on port %d" % int(port))
	multiplayer.multiplayer_peer = peer
	_on_player_connected(SERVER_PEER_ID)
	_register.rpc_id(SERVER_PEER_ID, "Host")
	_start_game()

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id: int) -> void:
	if multiplayer.is_server():
		players[id] = PlayerConnection.new()


func _on_player_disconnected(id: int) -> void:
	if multiplayer.is_server():
		if players[id].state == PlayerConnection.States.REGISTERED:
			chat.send_leave_game_msg.rpc(players[id].player_name)
		players.erase(id)


func _on_connected_ok() -> void:
	if timeout_tween:
		timeout_tween.kill()
	load_screen_button.hide()
	load_screen_text.text = "Registering..."
	_register.rpc_id(SERVER_PEER_ID, "Bob the client")
	_start_game()
	# TODO: Show register screen

func _on_connected_fail() -> void:
	_end_connection()
	load_screen_text.text = "Unable to connect to server."
	load_screen_button.show()


func _on_server_disconnected() -> void:
	_end_connection()
	players.clear()
	load_screen_text.text = "Server closed"
	load_screen_button.show()

func _remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()

# Source: https://github.com/godotengine/godot-docs-user-notes/discussions/57#discussioncomment-13819893
func _get_lan_ip() -> String:
	for ip in IP.get_local_addresses():
		if ip.is_valid_ip_address() \
		and ip.find('.') != -1 \
		and not ip.begins_with("127.") \
		and not ip.begins_with("169.254."):
			return ip
	push_error("No usable LAN IP found.")
	return ""

func _start_game() -> void:
	host_lan_button.disabled = true
	load_screen.hide()

func _end_connection() -> void:
	_remove_multiplayer_peer()
	load_screen.show()
	load_screen_button.show()
	game_ui.set_pause(false)
#endregion

#region Signal Handlers
func _on_chat_send_peers_msg(msg: String) -> void:
	_send_peers_msg.rpc_id(SERVER_PEER_ID, msg)

func _on_game_container_end_connection() -> void:
	_end_connection()
	#endregion

#region RPC
@rpc("any_peer", "call_local", "reliable")
func _register(player_name: String) -> void:
	if multiplayer.is_server():
		players[multiplayer.get_remote_sender_id()].player_name = player_name
		players[multiplayer.get_remote_sender_id()].state = PlayerConnection.States.REGISTERED
		chat.send_join_game_msg.rpc(player_name)

@rpc("any_peer", "call_local", "reliable")
func _send_peers_msg(msg: String) -> void:
	if multiplayer.is_server():
		if len(players) > 0:
			chat.send_player_msg.rpc(players[multiplayer.get_remote_sender_id()].player_name, msg)
		else:
			chat.send_player_msg("MESELF", msg)
#endregion
