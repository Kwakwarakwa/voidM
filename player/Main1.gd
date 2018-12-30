extends Node2D

var max_zoom = 5

func _on_Player_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
	
func _on_Player2_shoot(Laser_P2, _position, _direction):
	var a = Laser_P2.instance()
	add_child(a)
	a.start(_position, _direction)
	
func camera_pos():
	var p1_pos = $Player.get_position()
	var p2_pos = $Player_2.get_position()
	var newpos = (p1_pos + p2_pos) * 0.5
	$Camera.set_global_position(newpos)
	var distance = p1_pos.distance_to(p2_pos) *2
	var zoom_factor = distance * 0.005
	if zoom_factor > max_zoom:
		zoom_factor = max_zoom
	if zoom_factor < 1:
		zoom_factor = 1
	$Camera.set_zoom(Vector2(1,1) * zoom_factor / 2)

func _ready():
	$Player.speed = 0.1

func _process(delta):
	camera_pos()

