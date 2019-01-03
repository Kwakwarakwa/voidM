extends RigidBody2D

export (PackedScene) var Laser_P1
export (int) var speed = 1
var deadZone = 0.2
var engine_dir = Vector2(1,1)
var cannon_dir = Vector2(1,1)
var max_speed = 1
var can_shoot = true
var cannon_cooldown = 1
signal shoot
var stick_dir = Vector2()
var rot_speed = 3
var rot_dir = 0

func _ready():
	$gunTimer.wait_time = cannon_cooldown
	
func cannon_angle():
	if abs(Input.get_joy_axis(0, JOY_AXIS_3)) > deadZone or abs(Input.get_joy_axis(0, JOY_AXIS_2)) > deadZone:
		cannon_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_3) * -1, Input.get_joy_axis(0, JOY_AXIS_2))
		return cannon_dir
		
func control(delta): #cannon_angle_upgraded():
	# stworzenie var zawierającej Vector2 ze sticków
	if abs(Input.get_joy_axis(0, JOY_AXIS_3)) > deadZone or abs(Input.get_joy_axis(0, JOY_AXIS_2)) > deadZone:
		stick_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_3) * -1, Input.get_joy_axis(0, JOY_AXIS_2))
	# pobranie położenia sprite'a Cannon	
	var cannon_position = $Cannon.get_rotation()  * 0.85 #* 1.10714872  # przerobienie .rotation(radioany) na .angle (atan2)
	# warunki kiedy Cannon ma się poruszać
	"""
	if cannon_position >= 0 and stick_dir.angle() >= 0:
		if cannon_position > stick_dir.angle():
			rot_dir -= 1
		elif cannon_position < stick_dir.angle():
			rot_dir += 1
		$Cannon.rotation = (rot_speed * rot_dir * delta)
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	elif cannon_position < 0 and stick_dir.angle() < 0:
		if cannon_position < stick_dir.angle():
			rot_dir += 1
		elif cannon_position > stick_dir.angle():
			rot_dir -= 1
		$Cannon.rotation = (rot_speed * rot_dir * delta)
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	elif cannon_position >= 1.5 and stick_dir.angle() <= - 1.5:
		rot_dir += 1
		$Cannon.rotation = (rot_speed * rot_dir * delta) 
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	elif cannon_position <= -1.5 and stick_dir.angle() >= 1.5:
		rot_dir -= 1
		$Cannon.rotation = (rot_speed * rot_dir * delta) 
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	elif cannon_position <= stick_dir.angle():
		rot_dir += 1
		$Cannon.rotation = (rot_speed * rot_dir * delta)
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	elif cannon_position >= stick_dir.angle():
		rot_dir -= 1
		$Cannon.rotation = (rot_speed * rot_dir * delta)	
		if cannon_position == stick_dir.angle() - deadZone or cannon_position == stick_dir.angle() + deadZone:
			rot_dir = 0
	"""
	if cannon_position != stick_dir.angle():
		if cannon_position <= -2.975:
			rot_dir = 70
		if cannon_position >= 2.975:
			rot_dir = -70
		if cannon_position >= 1.5 and stick_dir.angle() <= - 1.5:
			rot_dir += 1
			$Cannon.rotation = (rot_speed * rot_dir * delta) 	
		elif cannon_position <= -1.5 and stick_dir.angle() >= 1.5:
			rot_dir -= 1
			$Cannon.rotation = (rot_speed * rot_dir * delta) 
		elif cannon_position <= stick_dir.angle() - deadZone and cannon_position <= stick_dir.angle() + deadZone:
			rot_dir += 1
			$Cannon.rotation = (rot_speed * rot_dir * delta)		
		elif cannon_position >= stick_dir.angle() - deadZone and cannon_position >= stick_dir.angle() + deadZone:
			rot_dir -= 1
			$Cannon.rotation = (rot_speed * rot_dir * delta)
	
	
	print(stick_dir.angle(), "  ",cannon_position, "    ", rot_dir)

	
		

func engine_angle():
	if abs(Input.get_joy_axis(0, JOY_AXIS_0)) > deadZone or abs(Input.get_joy_axis(0, JOY_AXIS_1)) > deadZone:
		engine_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
		return engine_dir

func throttle():
	if Input.is_action_pressed("gamepad_click"):
		add_force(Vector2(), (engine_dir * -1) * speed)

func check_max_speed():
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
    	var new_speed = get_linear_velocity().normalized()
    	new_speed *= max_speed
    	set_linear_velocity(new_speed)
		
func shoot():
    if can_shoot:
        #can_shoot = false
        $gunTimer.start()
        var dir = Vector2(1, 0).rotated($Cannon.global_rotation + 17.28)
        emit_signal('shoot', Laser_P1,
                $Cannon/Muzzle.global_position, dir)

				
func open_fire():
	if Input.is_action_just_pressed("fire"):
		shoot()
		
	
				
    
func _physics_process(delta):
	engine_angle()
	$Engine.set_rotation(engine_dir.angle())	
	#cannon_angle()
	#$Cannon.set_rotation(cannon_dir.angle())
	throttle()
	check_max_speed()
	open_fire()
	control(delta)
	


