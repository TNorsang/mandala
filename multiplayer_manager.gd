extends Node

@export var player_scene: PackedScene

var multiplayer_peer = ENetMultiplayerPeer.new()

func _ready():
	# Host if running as server, join if running as client
	if OS.has_feature("editor"):
		var is_host = true  # Change to false to join as client
		if is_host:
			host_game()
			spawn_player(multiplayer.get_unique_id())
		else:
			join_game("10.151.12.252")

func host_game(port = 12345):
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Hosting on port", port)
	spawn_player(multiplayer.get_unique_id())


func join_game(ip, port = 12345):
	multiplayer_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Joining", ip)

func _on_player_connected(id):
	print("Player connected:", id)

func _on_player_disconnected(id):
	print("Player disconnected:", id)

func spawn_player(peer_id):
	var player = player_scene.instantiate()
	add_child(player)
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)

func _on_connected_to_server():
	spawn_player(multiplayer.get_unique_id())

func _on_connection_succeeded():
	spawn_player(multiplayer.get_unique_id())

func _on_server_disconnected():
	print("Disconnected from server")

func _on_peer_connected(id):
	if id != multiplayer.get_unique_id():
		spawn_player(id)

func _on_peer_disconnected(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()

func _enter_tree():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
