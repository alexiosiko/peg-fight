extends Node

@export var host_button: Button
@export var connect_button: Button

const DEFAULT_IP = "127.0.0.1" # Use "127.0.0.1" or "localhost" for local machine testing
const PORT = 9999
func _ready() -> void:
	host_button.pressed.connect(_on_host_button)
	connect_button.pressed.connect(_on_connect_button)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
func _on_host_button() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error == OK:
		multiplayer.multiplayer_peer = peer
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		push_error("Failed to host")
func _on_connect_button() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP, PORT)
	multiplayer.multiplayer_peer = peer

func _on_connected_to_server() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
