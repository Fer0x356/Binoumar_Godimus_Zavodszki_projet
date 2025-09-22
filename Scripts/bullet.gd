extends Area2D

var speed = 750

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("Bullet hit: ", body.name, " | Groups: ", body.get_groups())
	if body.is_in_group("meteores"):
		print("-> Meteor touched!")
		if body.has_method("take_damage"):
			print("-> Meteor taking damage")
			body.take_damage(1)
		queue_free()
