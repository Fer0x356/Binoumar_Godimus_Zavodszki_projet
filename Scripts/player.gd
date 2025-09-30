extends RigidBody2D

const BULLET = preload("uid://kxk11e6gc30o")

var life = 3
var fire_rate : float = 0.15
var can_shoot : bool = true

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	var b = BULLET.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker3D.global_transform
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func _process(delta: float) -> void:
	look_at(get_global_mouse_position());
	rotation_degrees += 90
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		

func take_damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		queue_free()
