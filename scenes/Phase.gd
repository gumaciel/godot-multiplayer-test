extends Node2D

var num_players := 0
onready var pre_player = preload("res://scenes/Player.tscn")

func _ready() -> void:
	rpc("_player_ready")
	if not get_tree().is_network_server():
		get_tree().paused = true
	
	for i in range(Networking.players.size()):
		var player = pre_player.instance()
		player.position = Vector2(300, 200)
		add_child(player)
		player.set_network_master(Networking.players[i][0])
		player._change_name(Networking.players[i][1])
		player.name = "Player" + str(i)
		Networking._associate_node_player(i,player)
	
remotesync func _player_ready():
	num_players += 1
	if get_tree().is_network_server() and num_players == Networking.players.size():
		rpc("_start", num_players)
		
remotesync func _start(num_players):
	get_tree().paused = false
	self.num_players = num_players
	
