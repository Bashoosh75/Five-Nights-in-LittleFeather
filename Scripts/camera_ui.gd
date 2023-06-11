extends Control

var MapOpen = false
var PrevCam = 5
var Clearing = false
signal Moo
signal KebabDoor
signal OpenMap
signal ExitCams
signal ClearStart
signal ClearFinished
signal ClearCancelled
signal KebabBlocked
signal MinionFarted

func _ready():
	$Cameras/CameraMove.play("CameraMove")

func _on_change_cam_pressed():
	OpenMap.emit()
	if MapOpen == false:
		MapOpen = true
		$ChangeCam.text = "Cancel"
		$Admin.visible = false
	else:
		MapOpen = false
		$ChangeCam.text = "Change Cam"
		$Admin.visible = true


func _on_exit_pressed():
	ExitCams.emit()
	MapOpen = false
	$ChangeCam.text = "Change Cam"

# Cam numbers for reference
# PT : 1
# OT : 2
# SF : 3
# MB : 4
# KB : 5
# MT : 6
# BoH: 7
# C01: 8
# C02: 9
# CO3: 10

func _on_monitor_ui_cam_request(CamRequested):
	MapOpen = false
	$ChangeCam.text = "Change Cam"
	match PrevCam: # This is to make the currently viewed camera go invisible
		1: # PT
			$Cameras/PT.visible = false
		2: # OT
			pass
		3: # SF
			$Cameras/SF.visible = false
		4: # MB
			$Cameras/MB.visible = false
		5: # KB
			$Cameras/KB.visible = false
		6: # MT
			$Cameras/MT.visible = false
		7: # BoH
			pass
		8: # C01
			$Cameras/CAM.visible = false
		9: # C02
			$Cameras/CAM2.visible = false
		10: # C03
			pass
	PrevCam = CamRequested
	match CamRequested: # Make the camera the player wants to see visible
		1:
			$Cameras/PT.visible = true
		2: 
			pass
		3:
			$Cameras/SF.visible = true
		4:
			$Cameras/MB.visible = true
		5:
			$Cameras/KB.visible = true
		6:
			$Cameras/MT.visible = true
		7:
			pass
		8:
			$Cameras/CAM.visible = true
		9:
			$Cameras/CAM2.visible = true
		10:
			pass
	$Admin.visible = true

func _on_admin_pressed(): # The "Clear Lag" button
	if Clearing == false:
		ClearStart.emit()
		Clearing = true
		$Exit.visible = false
		$ChangeCam.visible = false
		$Admin/ClearingLabel.text = "Clearing entities..."
		$Admin/ClearingLabel.visible = true
		$Admin.text = "Cancel"
		$Cameras.visible = false
		$Admin/ClearSound.play()
	else:
		ClearFinished.emit()
		ClearCancelled.emit()
		Clearing = false
		$Admin/ClearSound.stop()
		$Exit.visible = true
		$ChangeCam.visible = true
		$Admin/ClearingLabel.visible = false
		$Cameras.visible = true
		$Admin.text = "Clear lag"

func _on_clear_sound_finished():
	ClearFinished.emit()
	Clearing = false
	$Exit.visible = true
	$ChangeCam.visible = true
	$Admin.text = "Clear lag"
	$Cameras.visible = true
	$Admin/ClearingLabel.text = "Cleared!"
	$Admin/LabelTimer.start(2)

func _on_label_timer_timeout():
	$Admin/ClearingLabel.visible = false


func _on_power_power_outage():
	$Admin/ClearSound.stop()


func _on_cameras_cowa_bunga(CowaBunga): # To pass the number of cows to the Main scene
	Moo.emit(CowaBunga)

func _on_cameras_kebaby_door():
	KebabDoor.emit()

func _on_main_king_gone():
	KebabBlocked.emit()

func _on_cameras_minion_break():
	MinionFarted.emit()
