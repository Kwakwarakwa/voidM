extends RigidBody2D

export (int) var speed = 0.5


var mouse_dir = Vector2()
var dir = Vector2()
var pos = Vector2()


func _input(event):
	if event.is_action_pressed("click"):
		pos = position
		mouse_dir = get_global_mouse_position()
		dir = (pos - mouse_dir) 
		apply_impulse(Vector2(), dir * speed)
		

func control(delta):
	$Engine.look_at(get_global_mouse_position())
	
    

func _physics_process(delta):
    control(delta)
