extends Area2D

var speed = 750

func _ready():
	# Configuration des collisions pour les projectiles
	collision_layer = 4  # Les projectiles sont sur la layer 4
	collision_mask = 2   # Les projectiles détectent la layer 2 (météores)

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("meteores"):
		if body.get_parent() and body.get_parent().has_method("take_damage"):
			body.get_parent().take_damage(1)
		queue_free()
