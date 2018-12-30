extends Area2D

export (int) var speed 
export (int) var damage
export (float) var lifetime 

var velocity = Vector2()

func start(_position, _direction):
    position = _position
    rotation = _direction.angle()
    $Timer.wait_time = 3 #lifetime
    velocity = _direction * 250 #speed

func _process(delta):
    position += velocity * delta

func explode():
    queue_free()
	
func _on_Bullet_body_entered(body):
    explode()
    if body.has_method('take_damage'):
        body.take_damage(damage)

func _on_Lifetime_timeout():
    explode()