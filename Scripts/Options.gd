extends Control

func _ready():
	SaveData.Phone = true

func _on_fullscreen_toggled(button_pressed):
	if button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_calls_toggled(button_pressed):
	if button_pressed == true:
		SaveData.Phone = true
	else:
		SaveData.Phone = false
