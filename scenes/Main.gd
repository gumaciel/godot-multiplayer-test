extends Control

func _process(delta: float) -> void:
	_update_list()

func _on_CreateButton_pressed() -> void:
	Networking._update_ip($Ip.text)
	Networking._update_name($Name.text)
	Networking._create_server()
	$CreateButton.disabled = true
	$EnterButton.disabled = true
	
func _on_EnterButton_pressed() -> void:
	Networking._update_ip($Ip.text)
	Networking._update_name($Name.text)
	Networking._enter_server()
	$CreateButton.disabled = true
	$EnterButton.disabled = true

func _update_list():
	var list = Networking._get_player_list()
	var my_id = Networking._get_connection_id()
	$ListConnectedsItemList.clear()
	for i in range(list.size()):
		var text = list[i][1]
		if list[i][0] == my_id:
			text += " (you)"
		$ListConnectedsItemList.add_item(text)
