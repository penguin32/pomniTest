extends TouchScreenButton

func _input(event):#btw, this instruction given below is not confined within this joystick
#This is how we override virtual function _input and it'll work everywhere the screen user has touched
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		print (event.position)
