extends Node2D

var axys := Vector2(0, 0)
var velocity := 50
var player_name = ""

func _change_name(new_name):
	player_name = new_name
	$Label.text = new_name

func _process(delta: float) -> void:
	if is_network_master():
		if Input.is_action_pressed("ui_up"):
			axys.y = -1
		elif Input.is_action_pressed("ui_down"):
			axys.y = 1
		else: 
			axys.y = 0
		
		if Input.is_action_pressed("ui_right"):
			axys.x = 1
		elif Input.is_action_pressed("ui_left"):
			axys.x = -1
		else:
			axys.x = 0
			
		rpc("_update_directions", axys)
	position += axys * velocity * delta
	if get_tree().is_network_server():
		rpc_unreliable("_update_position", position)

remote func _update_directions(directions):
	axys = directions

remote func _update_position(new_position):
	position = new_position
	print("_update_position")
	pass
