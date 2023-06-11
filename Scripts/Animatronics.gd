extends Control

signal CowaBunga
signal KebabyDoor
signal MinionBreak

var CowLevel
var KingLevel
var MinionLevel
var GrandmasterLevel
var RNG = RandomNumberGenerator.new()
var MinionRNG = RandomNumberGenerator.new()

var KebabyFail = 0 # If Kebabian King failed to move, guarantees movement next timeout
var MinionFail = 0
var GrandmasterFail = 0
var Clearing = false
var Night = SaveData.Night
var CowCount = 0
var KingLocation # 1, 2, 3 Portania  4, 5 Cam01  6  Door 0 inactive
var MinionLocation = 0 # 1 Base, 2 Crafting, 3 Leaving, 4 CAM01, 5 Door
var GrandmasterLocation = 0

func _ready():
	match Night:
		1:
			CowLevel = 2
			KingLevel = 3
			MinionLevel = 0
			GrandmasterLevel = 0
			$CowTimer.start(90) # Delay on the first night
			$MovementTimer.start(115) # 120, 160
		2:
			CowLevel = 3
			KingLevel = 5
			MinionLevel = 4
			GrandmasterLevel = 3
			$CowTimer.start(60)
			$MovementTimer.start(50)
			$MinionTimer.start(70)
	if CowLevel != 0:
		CowCount = 1
		$MT/Mt0Cow.visible = false
		$MT/Mt1Cow.visible = true
	if KingLevel != 0:
		KingLocation = 1
		$KB/KB0King.visible = false
		$KB/KB1King.visible = true
	if MinionLevel != 0:
		MinionLocation = 0
		$MB/Mb0Minion.visible = false
		$MB/Mb1Minion.visible = true
	if GrandmasterLevel != 0:
		$PT/PT0Grandmaster.visible = false
		$PT/PT1Grandmaster.visible = true

func _on_movement_timer_timeout():
	if KingLevel != 0:
		if RNG.randf_range(KingLevel, 20) <= KingLevel:
			KebabyFail = 0
			KingLocation += 1
		else:
			KebabyFail += 1
		if KebabyFail == 3:
			KebabyFail = 0
			KingLocation += 1
		match KingLocation:
			1:
				$KB/KB0King.visible = false
				$KB/KB1King.visible = true
			2:
				$KB/KB1King.visible = false
				$KB/KB2King.visible = true
			3:
				$KB/KB2King.visible = false
				$KB/KB3King.visible = true
			4:
				$KB/KB3King.visible = false
				$KB/KB0King.visible = true
				if $CAM/Cam01Minion.visible == true:
					$CAM/Cam01Minion.visible = false
					$CAM/Cam01KingMinion1.visible = true
				else:
					$CAM/Cam01Nobody.visible = false
					$CAM/Cam01King1.visible = true
			5:
				if $CAM/Cam01KingMinion1.visible == true:
					$CAM/Cam01KingMinion1.visible = false
					$CAM/Cam01KingMinion2.visible = true
				else:
					$CAM/Cam01King1.visible = false
					$CAM/Cam01King2.visible = true
			6:
				if $CAM/Cam01KingMinion2.visible == true:
					$CAM/Cam01KingMinion2.visible = false
					$CAM/Cam01Minion.visible = true
				else:
					$CAM/Cam01King2.visible = false
					$CAM/Cam01Nobody.visible = true
				KebabyDoor.emit()
			8:
				KingLocation = 7
	if GrandmasterLevel != 0:
		if RNG.randf_range(GrandmasterLevel, 20) <= GrandmasterLevel:
			GrandmasterFail = 0
			GrandmasterLocation += 1
		else:
			GrandmasterFail += 1
		if GrandmasterFail == 3:
			GrandmasterFail = 0
			GrandmasterLocation += 1
		match GrandmasterLocation:
			1:
				$PT/PT0Grandmaster.visible = false
				$PT/PT1Grandmaster.visible = true
			2:
				$PT/PT1Grandmaster.visible = false
				$PT/PT2Grandmaster.visible = true
			3:
				$PT/PT2Grandmaster.visible = false
				$PT/PT0Grandmaster.visible = true
				$CAM2/Cam02Nobody.visible = false
				$CAM2/Cam02Grandmaster.visible = true
			5:
				GrandmasterLocation = 4
	$MovementTimer.start(10)

func _on_camera_ui_clear_start():
	Clearing = true

func _on_cow_timer_timeout():
	if Clearing == false and $MT.visible == false:
		CowCount += 1
	#else:
	#	print("i cant COW!!!")
		match CowCount:
			2:
				$MT/Mt1Cow.visible = false
				$MT/Mt2Cow.visible = true
			4:
				$MT/Mt2Cow.visible = false
				$MT/Mt3Cow.visible = true
			6:
				$MT/Mt3Cow.visible = false
				$MT/Mt4Cow.visible = true
			8:
				$MT/Mt4Cow.visible = false
				$MT/Mt5Cow.visible = true
			11:
				CowCount = 10
		CowaBunga.emit(CowCount)
	$CowTimer.start(30 - CowLevel)

func _on_clear_sound_finished():
	Clearing = false
	if $MT.visible == true:
		CowCount -= 2
		if CowCount < 1:
			CowCount = 1
		match CowCount:
			1:
				$MT/Mt2Cow.visible = false
				$MT/Mt1Cow.visible = true
			2:
				$MT/Mt3Cow.visible = false
				$MT/Mt2Cow.visible = true
			3:
				$MT/Mt3Cow.visible = false
				$MT/Mt2Cow.visible = true
			4:
				$MT/Mt4Cow.visible = false
				$MT/Mt3Cow.visible = true
			5:
				$MT/Mt4Cow.visible = false
				$MT/Mt3Cow.visible = true
			6:
				$MT/Mt5Cow.visible = false
				$MT/Mt4Cow.visible = true
			7:
				$MT/Mt5Cow.visible = false
				$MT/Mt4Cow.visible = true
		CowaBunga.emit(CowCount)
	elif $MB.visible == true and MinionLocation == 2:
		MinionLocation = 0
		$MB/Mb0Minion.visible = true
		$MB/Mb2Minion.visible = false

func _on_camera_ui_clear_cancelled():
	Clearing = false


func _on_camera_ui_kebab_blocked():
	KingLocation = 1
	$KB/KB0King.visible = false
	$KB/KB1King.visible = true

func _on_minion_timer_timeout():
	if MinionRNG.randf_range(MinionLevel, 20) <= MinionLevel:
		MinionFail = 0
		MinionLocation += 1
	else:
		MinionFail += 1
	if MinionFail == 2:
		MinionFail = 0
		MinionLocation += 1
	match MinionLocation:
		1: # Base
			$MB/Mb0Minion.visible = false
			$MB/Mb1Minion.visible = true
		2: # Crafting
			$MB/Mb1Minion.visible = false
			$MB/Mb2Minion.visible = true
		3: # Leaving base
			$MB/Mb2Minion.visible = false
			$MB/Mb3Minion.visible = true
		4: # Cam01
			$MB/Mb3Minion.visible = false
			$MB/Mb0Minion.visible = true
			if $CAM/Cam01King1.visible == true:
				$CAM/Cam01KingMinion1.visible = true
			elif $CAM/Cam01King2.visible == true:
				$CAM/Cam01KingMinion2.visible = true
			else:
				$CAM/Cam01Nobody.visible = false
				$CAM/Cam01Minion.visible = true
		5:
			if $CAM/Cam01KingMinion1.visible == true:
				$CAM/Cam01KingMinion1.visible = false
				$CAM/Cam01King1.visible = true
			elif $CAM/Cam01KingMinion2.visible == true:
				$CAM/Cam01KingMinion2.visible = false
				$CAM/Cam01King2.visible = true
			else:
				$CAM/Cam01Minion.visible = false
				$CAM/Cam01Nobody.visible = true
			MinionLocation = 0
			MinionBreak.emit()
	if MinionLocation == 2:
		$MinionTimer.start(MinionLevel - 40) # 40
	elif MinionLocation == 1:
		$MinionTimer.start(MinionLevel - 30) # 20????
	else:
		$MinionTimer.start(15) # 15
