extends Node

var SteveRNG = RandomNumberGenerator.new()
#var calledAlready = false
#var LoopLimit = 1

func _on_options_pressed():
	$Main.visible = false
	$Options.visible = true

func _on_return_pressed():
	$Options.visible = false
	$Main.visible = true

func _on_timer_timeout():
	var AnimNUM = SteveRNG.randi_range(1, 5)
	var TimeNUM = SteveRNG.randi_range(3, 6)
	match AnimNUM:
		1:
			$Main/RightAnchor/Steve.play("crazy1")
		2:
			$Main/RightAnchor/Steve.play("crazy2")
		3:
			$Main/RightAnchor/Steve.play("crazybig")
		4:
			$Main/RightAnchor/Steve.play("quickcrazy")
		5:
			$Main/RightAnchor/Steve.play("stare")
	$Timer.start(TimeNUM)

func _on_warning_timer_timeout():
	$Warning.visible = false
	$Main.visible = true
	$Music.play()
#	if calledAlready == true:
#		while LoopLimit != 0:
#			$Warning/Label.modulate
#	else:
#		calledAlready = true
#		$Warning/WarningTimer.start(0.3)

func _on_new_game_pressed():
	$Music.volume_db = -20
	#$Music.stop()
	#$AltMusic.play()
	$Main.visible = false
	$Warning/News.visible = true
	$Warning.visible = true
	SaveData.Night = 1

func _on_news_continue_pressed():
	$Warning.visible = false
	$Music.stop()
	#$AltMusic.stop()
	$NightIntro.visible = true
	$NightIntro/Lightning.play()

func _on_continue_pressed():
	$Music.stop()
	$Main.visible = false
	SaveData.Night = 2
	$NightIntro.visible = true
	$NightIntro/Label.text = "Night 2"
	$NightIntro/Lightning.play()

func _on_lightning_finished():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
