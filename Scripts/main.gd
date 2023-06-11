extends Node3D

signal KingGone
var NightComplete = false
var RNG = RandomNumberGenerator.new()
var KingInside = false
var DoorCooldown = false
var KingCounter = 0
var OutageCounter
var Hour = 0

func _on_r_lamp_button_pressed():
	if $Game/Power/RedstoneLampLight.visible == false:
		$Game/Power/RedstoneLampLight.visible = true
		$Game/Power/RedstoneLampLight/RedstoneLampOFF.stop()
		$Game/Power/RedstoneLampLight/RedstoneLampON.play()
		$Game/Power/RedstoneLampLight/RedstoneLampLOOP.play()
	else:
		$Game/Power/RedstoneLampLight.visible = false
		$Game/Power/RedstoneLampLight/RedstoneLampLOOP.stop()
		$Game/Power/RedstoneLampLight/RedstoneLampON.stop()
		$Game/Power/RedstoneLampLight/RedstoneLampOFF.play()

func _on_door_button_pressed():
	if DoorCooldown == false:
		DoorCooldown = true
		if $Game/Power/IronBar.get_meta("Closed") == false:
			$Game/Power/IronBar.set_meta("Closed", true)
			$Game/Power/IronBar/AnimationPlayer.play("Close")
			$Game/Power/IronBar/Closing.play()
		else:
			$Game/Power/IronBar.set_meta("Closed", false)
			$Game/Power/IronBar/AnimationPlayer.play("Open")
			$Game/Power/IronBar/Opening.play()
		$Game/Power/IronBar/Cooldown.start(0.8)

func _on_cooldown_timeout():
	DoorCooldown = false

func _on_cam_button_pressed():
	$Cameras/CamsOFF.stop()
	$RotatingCam.visible = false
	$CameraPivot/CamButton.visible = false
	$CameraPivot/PlayerLight.visible = false
	$CameraPivot/CamButton.visible = false
	$PCLight.visible = false
	$Cameras.visible = true
	$Cameras/CamsON.play()
	if $Game/Power/RedstoneLampLight.visible == true:
		$Game/Power/RedstoneLampLight.visible = false
		$Game/Power/RedstoneLampLight/RedstoneLampLOOP.stop()
		$Game/Power/RedstoneLampLight/RedstoneLampOFF.play()

func _on_cams_on_finished():
	$Cameras/StartupStatic.visible = false
	$Cameras/CamsIDLE.play()

func _on_camera_ui_exit_cams():
	$Cameras/CamsON.stop()
	$Cameras.visible = false
	$Cameras/MonitorUI.visible = false
	$Cameras/CamsIDLE.stop()
	$Cameras/CamsOFF.play()
	$RotatingCam.visible = true
	$CameraPivot/CamButton.visible = true
	$CameraPivot/PlayerLight.visible = true
	$PCLight.visible = true
	$Cameras/StartupStatic.visible = true


func _on_monitor_ui_cam_request(_CamRequested):
	$Cameras/StartupStatic.visible = true
	$Cameras/CamChange.play()

func _on_cam_change_finished():
	$Cameras/StartupStatic.visible = false

func _on_power_power_outage():
	$Ambience.stop()
	$RotatingCam.visible = false
	$CameraPivot/PlayerLight.visible = false
	$CameraPivot/CamButton.visible = false
	$CameraPivot/RLampButton.visible = false
	$CameraPivot/DoorButton.visible = false
	$CameraPivot/PlayerLight.light_energy = 0.1
	$PCLight.visible = false
	$Cameras.visible = false
	$Cameras/CamsIDLE.stop()
	if $Game/Power/IronBar.get_meta("Closed") == true:
		$Game/Power/IronBar.set_meta("Closed", false)
		$Game/Power/IronBar/AnimationPlayer.play("Open")
		$Game/Power/IronBar/Opening.play()
	if $Game/Power/RedstoneLampLight.visible == true:
		$Game/Power/RedstoneLampLight.visible = false
		$Game/Power/RedstoneLampLight/RedstoneLampLOOP.stop()
		$Game/Power/RedstoneLampLight/RedstoneLampOFF.play()
	OutageCounter = 0
	$Game/Power/OutageTimer.start(5)
	$CameraPivot/AnimationPlayer.play("TurnWINDOW2PC")

func _on_outage_timer_timeout():
	if OutageCounter != 6:
		OutageCounter += 1
		if $CameraPivot/PlayerLight.visible == true:
			$CameraPivot/PlayerLight.visible = false
		else:
			$CameraPivot/PlayerLight.visible = true
		$Game/Power/OutageTimer.start(0.1)
	else:
		$CameraPivot/AnimationPlayer.play("PCPowerOut")
		$CameraPivot/PlayerLight.visible = true


func _on_camera_ui_kebab_door():
	$King.visible = true
	$King/KingTimer.start(5)


func _on_king_timer_timeout():
	if $Game/Power/IronBar.get_meta("Closed") == true and KingInside == false and $Game/Power/IronBar.visible == true:
		$King.visible = false
		KingGone.emit()
	else:
		if KingCounter == 3:
			if KingInside == true and NightComplete == false:
				$King.visible = true
				$King/Screen.visible = true
				$Cameras.visible = false
				$CameraPivot/AnimationPlayer.play("KebabyJumpscare")
				$KebabyScary.play()
			elif $Game/Power/RedstoneLampLight.visible == false:
				KingInside = true
				$King.visible = false
				$King/KingTimer.start(RNG.randf_range(1, 20))
			else:
				$King/KingTimer.start(5)
		else:
			$King/KingTimer.start(5)
			KingCounter += 1

func _on_kebaby_scary_finished():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_clock_night_complete():
	NightComplete = true

func _on_update_timeout(): # Power update
	$Cameras/Power.text = str($Game/Power.get_meta("Power")) + "% Power"
	match $Game/Power.get_meta("Usage"):
		1:
			$Cameras/Usage.text = "Usage: I"
		2:
			$Cameras/Usage.text = "Usage: II"
		3:
			$Cameras/Usage.text = "Usage: III"
		4:
			$Cameras/Usage.text = "Usage: IIII"
		5:
			$Cameras/Usage.text = "Usage: IIIII"


func _on_clock_timer_timeout():
	Hour += 1
	$Cameras/Time.text = str(Hour) + " AM"


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "PCPowerOut":
		$Game/Power/OutageDeathTimer.start(RNG.randf_range(1, 20))

func _on_outage_death_timer_timeout():
	$King.visible = true
	$King/Screen.visible = true
	$CameraPivot/AnimationPlayer.play("KebabyJumpscare")
	$KebabyScary.play()
