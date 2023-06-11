extends Node3D

func _ready():
	if SaveData.Night == 1 and SaveData.Phone == true:
		$Night1Call.play()
	elif SaveData.Night == 2 and SaveData.Phone == true:
		$Night2Call.play()
