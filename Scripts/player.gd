extends RigidBody2D

signal perteHP

const BULLET = preload("uid://kxk11e6gc30o")
@export var game_over: PackedScene
@onready var shoot_sound: AudioStreamPlayer2D = $"../ShootSound"
@onready var death_sound: AudioStreamPlayer2D = $"../DeathSound"
@onready var take_damages: AudioStreamPlayer2D = $"../TakeDamage"

var life = 3
var fire_rate : float = 0.15
var can_shoot : bool = true

func _ready():
	# Configuration des collisions pour le joueur
	collision_layer = 1  # Le joueur est sur la layer 1
	collision_mask = 0   # Le joueur ne réagit pas physiquement aux autres objets

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	var b = BULLET.instantiate()
	owner.add_child(b)
	b.global_transform = $Marker3D.global_transform
	shoot_sound.play()
	
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func _process(delta: float) -> void:
	look_at(get_global_mouse_position());
	rotation_degrees += 90
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

func take_damage(amount: int) -> void:
	life -= amount
	emit_signal("perteHP")
	if visible == true:
		take_damages.play()
	if life <= 0:
		if visible == true :
			death_sound.play()
		self.visible = false
		
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_packed(game_over)
		queue_free()
