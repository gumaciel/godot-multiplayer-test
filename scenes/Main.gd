extends Control

func _process(delta: float) -> void:
	_update_list()
	if Networking.connection_fail:
		$ErrorMessagePanel.show()

func _on_CreateButton_pressed() -> void:
	Networking._update_ip($Ip.text)
	Networking._update_name($Name.text)
	Networking._create_server()
	$Ip.text = Networking._get_server_ip()
	$Ip.editable = false
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


func _on_StartButton_pressed() -> void:
	Networking._start_game()


func _on_ConfirmButton_pressed() -> void:
	Networking._reset_connection()
	$ErrorMessagePanel.hide()
	$Ip.editable = true
	$StartButton.disabled = false
	$EnterButton.disabled = false
	$CreateButton.disabled = false
