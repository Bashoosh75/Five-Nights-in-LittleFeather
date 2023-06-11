extends Node3D

var Power
var Usage
var Light
var Door
var Cams
var Clear
var Max
var DoorHealth = 2
signal PowerOutage


func _ready():
	Power = 100
	Usage = 1
	Light = 0
	Door = 0
	Cams = 0
	Clear = 0
	Max = 100

func _on_r_lamp_button_pressed():
	if Light == 0:
		Light = 1
	else:
		Light = 0

func _on_door_button_pressed():
	if $IronBar.get_meta("Closed") == true:
		Door = 1
	else:
		Door = 0

func _on_cam_button_pressed(): # If the camera is opened
	Cams = 1
	Light = 0

func _on_camera_ui_exit_cams(): # If the camera is closed
	Cams = 0

func _on_camera_ui_clear_start(): # If the player starts clearing
	Clear = 1

func _on_camera_ui_clear_finished():
	Clear = 0


func _on_camera_ui_moo(CowaBunga):
	match CowaBunga:
		1:
			Max = 100
		2:
			Max = 85
		3:
			Max = 80
		4:
			Max = 70
		5:
			Max = 65
		6:
			Max = 55
		7:
			Max = 50
		8: 
			Max = 45
		9:
			Max = 35
		10:
			Max = 25

func _on_update_timeout():
	Usage = Light + Door + Cams + Clear + 1
	if Usage == 1 and Power < Max:
		Power += 5
		if Power > Max:
			Power = Max
	elif Usage != 1:
		Power -= Usage
	$Monitor/Screen/SubViewport/Control/Power.text = "Power: " + str(Power) + "%"
	match Usage:
		1:
			$Monitor/Screen/SubViewport/Control/Usage.text = "Usage: I"
		2:
			$Monitor/Screen/SubViewport/Control/Usage.text = "Usage: II"
		3:
			$Monitor/Screen/SubViewport/Control/Usage.text = "Usage: III"
		4:
			$Monitor/Screen/SubViewport/Control/Usage.text = "Usage: IIII"
		5: # It should be impossible for the player to get this, but if they do then wow...
			$Monitor/Screen/SubViewport/Control/Usage.text = "Usage: IIIII"
	if Power <= 0:
		PowerOutage.emit()
		$Update.stop()
		$Monitor/Screen/SubViewport/Control.visible = false
		$PowerDown.play()
	self.set_meta("Power", Power)
	self.set_meta("Usage", Usage)

func _on_camera_ui_minion_farted():
	if DoorHealth != 0:
		$IronBar/MinionBreak.play()
		DoorHealth -= 1
	else:
		$IronBar.visible = false
		$IronBar/DoorBreak.play()
