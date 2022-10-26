extends Node

const DEFAULT_IP := "127.0.0.1"
const DEFAULT_PORT := 6007
const MAX_PLAYERS = 5

var ip := DEFAULT_IP
var player_name := "Player"
var connection_id : int

var players := []
var peer : NetworkedMultiplayerENet = null

func _ready() -> void:
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	get_tree().connect("connection_failed", self, "_on_connection_failed")

func _on_connected_to_server():
	rpc("_register_player", get_tree().get_network_unique_id(), player_name)
	
func _on_server_disconnected():
	get_tree().quit()
	
func _on_peer_disconnected(id): #client disconnected
	rpc("remove_player", id)

remote func _register_player(id, player_name):
	if get_tree().is_network_server():
		for i in range(players.size()):
			rpc_id(id, "_register_player", players[i][0], players[i][1])
		rpc("_register_player", id, player_name)
	players.append([id, player_name])

remotesync func _remove_player(id):
	print("hi1")
	for i in range(players.size()):
		if players[i][0] == id:
			players.remove(i)

func _update_ip(new_ip):
	ip = new_ip
	
func _update_name(new_name):
	player_name = new_name

func _create_server():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	connection_id = get_tree().get_network_unique_id()
	peer.connect("peer_disconnected", self, "_on_peer_disconnected")
	_register_player(connection_id, player_name)

func _enter_server():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().network_peer = peer
	connection_id = get_tree().get_network_unique_id()

func _get_player_list():
	return players
	
func _get_connection_id():
	return connection_id
