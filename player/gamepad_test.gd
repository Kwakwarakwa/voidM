extends Node2D

# class member variables go here, for example:


func _ready():
	pass

func _process(delta):
	var a = Input.get_joy_axis(0, JOY_AXIS_0)
	var b = Input.get_joy_axis(0, JOY_AXIS_1)
	print(Vector2(a,b))
