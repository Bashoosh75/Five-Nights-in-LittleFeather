extends Control

signal rotateRight
signal rotateLeft

func _on_left_prox_mouse_entered():
	$Left.visible = true

func _on_right_prox_mouse_entered():
	$Right.visible = true

func _on_center_prox_mouse_entered():
	if $Left.visible == true:
		$Left.visible = false
	else:
		$Right.visible = false

#func _on_left_pressed():
#	$Left.visible = false
#	$LeftProx.visible = false
#	$RightProx.visible = false
#	rotateLeft.emit()
#	$Timer.start(0.3)

#func _on_right_pressed():
#	$Left.visible = false
#	$LeftProx.visible = false
#	$RightProx.visible = false
#	$Right.visible = false
#	rotateRight.emit()
#	$Timer.start(0.3)

func _on_timer_timeout():
	$LeftProx.visible = true
	$RightProx.visible = true

# Rather than clicking

func _on_left_mouse_entered():
	$Left.visible = false
	$LeftProx.visible = false
	$RightProx.visible = false
	$Right.visible = false
	rotateLeft.emit()
	$Timer.start(0.3)


func _on_right_mouse_entered():
	$Left.visible = false
	$LeftProx.visible = false
	$RightProx.visible = false
	$Right.visible = false
	rotateRight.emit()
	$Timer.start(0.3)
