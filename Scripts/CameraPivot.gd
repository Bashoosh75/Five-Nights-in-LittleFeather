extends Marker3D

var lookingAt = 1 # 1 is PC, 2 is DOOR, 3 is COUNTER, 4 is WINDOW

func _on_rotating_cam_rotate_right():
	match lookingAt:
		1:
			$AnimationPlayer.play("TurnPC2Door")
			lookingAt = 2
			$CamButton.visible = false
		2:
			$AnimationPlayer.play("TurnDOOR2COUNTER")
			lookingAt = 3
			$RLampButton.visible = true
		3:
			$AnimationPlayer.play("TurnCOUNTER2WINDOW")
			lookingAt = 4
			$RLampButton.visible = false
			$DoorButton.visible = true
		4:
			$AnimationPlayer.play("TurnWINDOW2PC")
			lookingAt = 1
			$DoorButton.visible = false
			$CamButton.visible = true

func _on_rotating_cam_rotate_left():
	match lookingAt:
		1:
			$AnimationPlayer.play_backwards("TurnWINDOW2PC")
			lookingAt = 4
			$DoorButton.visible = true
			$CamButton.visible = false
		2:
			$AnimationPlayer.play_backwards("TurnPC2Door")
			lookingAt = 1
			$CamButton.visible = true
		3:
			$AnimationPlayer.play_backwards("TurnDOOR2COUNTER")
			lookingAt = 2
			$RLampButton.visible = false
		4:
			$AnimationPlayer.play_backwards("TurnCOUNTER2WINDOW")
			lookingAt = 3
			$RLampButton.visible = true
			$DoorButton.visible = false

