extends MeshInstance3D

var Hour = 0
signal NightComplete

func _on_clock_timer_timeout():
	Hour += 1
	$Screen/SubViewport/Label.text = str(Hour) + " AM"
	if Hour == 6:
		NightComplete.emit()
		$Beep.play()

func _on_beep_finished():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
