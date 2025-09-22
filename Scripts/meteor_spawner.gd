extends Marker2D

const Meteor = preload("res://Ennemies/meteor.tscn")

@export var spawn_area_width: float = 800
@export var spawn_interval: float = 1.0

func _ready() -> void:
	$MeteorTimer.wait_time = spawn_interval
	$MeteorTimer.timeout.connect(_on_MeteorTimer_timeout)

func _on_MeteorTimer_timeout() -> void:
	spawn()

func spawn() -> void:
	var meteor = Meteor.instantiate()
	var random_offset = randf_range(-spawn_area_width/2, spawn_area_width/2)
	meteor.position = Vector2(position.x + random_offset, position.y)
	get_parent().add_child(meteor)
	print("Meteor spawned")
