extends RigidBody2D

export (PackedScene) var Laser_P1
export (int) var speed = 1
var deadZone = 0.2
var max_speed = 1
var can_shoot = true
var cannon_cooldown = 1
signal shoot
var cannon_stick_dir = Vector2()
var cannon_dir_vector = Vector2()
var engine_stick_dir = Vector2()
var engine_dir_vector = Vector2()
var rot_speed = 3
var rot_dir = 0
var eng_rot = 0
var health = 100
var engine_thruster  = Vector2()

func _ready():
	$gunTimer.wait_time = cannon_cooldown
	
							# PORUSZANIE SIĘ
		
func control(delta): #cannon_angle_upgraded():
	# stworzenie var zawierającej Vector2 ze sticków
	if abs(Input.get_joy_axis(0, JOY_AXIS_3)) > deadZone or abs(Input.get_joy_axis(0, JOY_AXIS_2)) > deadZone:
		cannon_stick_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_3) * -1, Input.get_joy_axis(0, JOY_AXIS_2))
	# pobranie położenia sprite'a Cannon	
	var cannon_position = $Cannon.get_rotation()  * 0.85 #* 1.10714872  # przerobienie .rotation(radioany) na .angle (atan2)
	# warunki kiedy Cannon ma się poruszać
	if cannon_position != cannon_stick_dir.angle():
		cannon_dir_vector = Vector2(cos($Cannon.get_rotation()), sin($Cannon.get_rotation())) * -1
		if cannon_position != cannon_stick_dir.angle():
			if cannon_dir_vector.angle_to(cannon_stick_dir) >= 0:
				rot_dir -= 1
				$Cannon.rotation = (rot_speed * rot_dir * delta) 
			elif cannon_dir_vector.angle_to(cannon_stick_dir) < 0:
				rot_dir += 1
				$Cannon.rotation = (rot_speed * rot_dir * delta) 
			else:
				rot_speed = 0
			
	# Stworzenie sterowania dla silnika
		if abs(Input.get_joy_axis(0, JOY_AXIS_0)) > deadZone or abs(Input.get_joy_axis(0, JOY_AXIS_1)) > deadZone:
			engine_stick_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
		var engine_position = ($Engine.get_rotation()  * 0.85) 
		engine_dir_vector = Vector2(cos($Engine.get_rotation()), sin($Engine.get_rotation())) * -1
		if engine_position != engine_stick_dir.angle():
			if engine_dir_vector.angle_to(engine_stick_dir) >= 0:
				eng_rot -= 1
				$Engine.rotation = (rot_speed * eng_rot * delta) 
			elif engine_dir_vector.angle_to(engine_stick_dir) < 0:
				eng_rot += 1
				$Engine.rotation = (rot_speed * eng_rot * delta) 
			else:
				rot_speed = 0

		# nadanie pędu od silnika a nie od sticka
		engine_thruster = Vector2(cos($Engine.get_rotation()), sin($Engine.get_rotation()))
		return engine_thruster
# moze warto zrobić osobne funkcje control dla silnika ( wraz z opcją throttle i max speed) i działa?

func throttle():
	if Input.is_action_pressed("gamepad_click"):
		add_force(Vector2(), (engine_thruster * -1) * speed)

func check_max_speed():
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
    	var new_speed = get_linear_velocity().normalized()
    	new_speed *= max_speed
    	set_linear_velocity(new_speed)
		
							# STRZELANIE
							
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
    
							# OBRAŻENIA

func take_damage(amount):
	health -= amount
	emit_signal("health_changed")
	if health <= 0:
		expolde()

func expolde():
	queue_free()
	print("exploded")
							# MAIN
	
func _physics_process(delta):
	throttle()
	check_max_speed()
	open_fire()
	control(delta)
	


