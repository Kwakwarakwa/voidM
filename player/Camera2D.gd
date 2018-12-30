extends Camera2D

func _ready():
    set_process(true)
	
	
func _process(delta):
    var p1_pos = $Player.get_pos()
    var p2_pos = $Player_2.get_pos()
    var newpos = (p1_pos+p2_pos) * 0.5
    $Camera.set_global_pos(newpos)
    var distance = p1_pos.distance_to(p2_pos) * 2
    var zoom_factor = distance * 0.005
    $Camera.set_zoom(Vector2(1,1) * zoom_factor / 2) 
	