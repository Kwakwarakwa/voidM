extends RigidBody2D

export (int) var speed = 100
export (int) var engine_rotation_speed = 0.2

var pad_dir = Vector2()

func _input(event):
	if event.is_action_pressed("gamepad_click"):
		pad_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0),
		Input.get_joy_axis(0, JOY_AXIS_1)) * -1
		apply_impulse(Vector2(), pad_dir * speed)
			
func control(delta):
	var engine_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), 
	Input.get_joy_axis(0, JOY_AXIS_1))
	var engine_position = Vector2()
	#zeby silnik nie wracal do pozycji 0
	if Input.get_joy_axis(0, JOY_AXIS_0) != 0 or Input.get_joy_axis(0, JOY_AXIS_1) != 0:
		engine_position = engine_dir
	$Engine.set_rotation(engine_dir.angle())
    
func _physics_process(delta):
	control(delta)
	var engine_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), 
	Input.get_joy_axis(0, JOY_AXIS_1))
	
	
	print(engine_dir.angle())
    
	
    
