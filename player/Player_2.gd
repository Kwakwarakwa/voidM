extends RigidBody2D

export (PackedScene) var Laser_P2
export (int) var speed = 0.8
var deadZone = 0.2
var engine_dir = Vector2(1,1)
var cannon_dir = Vector2()
var max_speed = 1
var can_shoot = true
var cannon_cooldown = 1
signal shoot_2
var health = 100

func _ready():
	$gunTimer.wait_time = cannon_cooldown

func cannon_angle():
	if abs(Input.get_joy_axis(1, JOY_AXIS_3)) > deadZone or abs(Input.get_joy_axis(1, JOY_AXIS_2)) > deadZone:
		cannon_dir = Vector2(Input.get_joy_axis(1, JOY_AXIS_3) * -1, Input.get_joy_axis(1, JOY_AXIS_2))
		return cannon_dir

func engine_angle():
	if abs(Input.get_joy_axis(1, JOY_AXIS_0)) > deadZone or abs(Input.get_joy_axis(1, JOY_AXIS_1)) > deadZone:
		engine_dir = Vector2(Input.get_joy_axis(1, JOY_AXIS_0), Input.get_joy_axis(1, JOY_AXIS_1))
		return engine_dir

func throttle():
	if Input.is_action_pressed("Player2_throttle"):
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
        emit_signal('shoot_2', Laser_P2,
                $Cannon/Muzzle.global_position, dir)

func open_fire():
	if Input.is_action_just_pressed("Player2_fire"):
		shoot()
		
func take_damage(amount):
	health -= amount
	emit_signal("health_changed")
	if health <= 0:
		expolde()

func expolde():
	queue_free()
	print("exploded")

func _physics_process(delta):
	engine_angle()
	$Engine.set_rotation(engine_dir.angle())
	cannon_angle()
	$Cannon.set_rotation(cannon_dir.angle())
	throttle()
	check_max_speed()
	open_fire()

