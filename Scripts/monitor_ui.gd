extends Control

signal CamRequest
var CamRequested

func _on_camera_ui_open_map():
	if self.visible == false:
		self.visible = true
	else:
		self.visible = false

# Cam numbers for reference to be signaled
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

func _on_pt_pressed():
	CamRequested = 1
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_ot_pressed():
	CamRequested = 2
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_sf_pressed():
	CamRequested = 3
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_mb_pressed():
	CamRequested = 4
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_kb_pressed():
	CamRequested = 5
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_mt_pressed():
	CamRequested = 6
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_bo_h_pressed():
	CamRequested = 7
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_cam_01_pressed():
	CamRequested = 8
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_cam_02_pressed():
	CamRequested = 9
	CamRequest.emit(CamRequested)
	self.visible = false

func _on_cam_03_pressed():
	CamRequested = 10
	CamRequest.emit(CamRequested)
	self.visible = false
