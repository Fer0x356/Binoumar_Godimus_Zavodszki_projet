extends RigidBody2D

const BULLET = preload("uid://kxk11e6gc30o")

var life = 3

func shoot():
	var b = BULLET.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker3D.global_transform
	
func _process(delta: float) -> void:
	look_at(get_global_mouse_position());
	rotation_degrees += 90
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		queue_free()
