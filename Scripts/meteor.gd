extends Node2D

# Signal pour prévenir qu'un météore est détruit
signal meteor_destroyed

var character_body: CharacterBody2D
var collider: CollisionShape2D
var area_collider: CollisionShape2D
var sprite: Sprite2D

# Sons
@onready var explosion_sound: AudioStreamPlayer2D = $"ExplosionSound"
@onready var explode_sound = $ExplodeSound if has_node("ExplodeSound") else null

@onready var explosion_animation: AnimatedSprite2D = $CharacterBody2D/ExplosionAnimation

var is_dying: bool = false

var randomGenerator := RandomNumberGenerator.new()
var randomSize: float
var randomRotationSpeed: float
var life: int
var speed: float
var direction: Vector2

func _ready() -> void:
	character_body = $CharacterBody2D
	collider = $CharacterBody2D/CollisionShape2D
	area_collider = $CharacterBody2D/Area2D/CollisionShape2D
	sprite = $CharacterBody2D/Sprite2D
	
	# Connecter le signal de l'Area2D
	var area = $CharacterBody2D/Area2D
	if area and not area.body_entered.is_connected(_on_body_entered):
		area.body_entered.connect(_on_body_entered)
	
	# Configuration des collisions : les météores ne se bloquent pas entre eux
	character_body.collision_layer = 2  # Les météores sont sur la layer 2
	character_body.collision_mask = 1   # Les météores détectent seulement la layer 1 (joueur, murs, etc.)
	
	randomGenerator.randomize()
	randomSize = randomGenerator.randi_range(2, 8)
	var scale_vec = Vector2(randomSize, randomSize)
	collider.scale = scale_vec
	area_collider.scale = scale_vec
	sprite.scale = scale_vec
	
	# change la taille de l'explosion en fonction de la taille du meteor (0.3 car sinon c'est trop grand)
	if explosion_animation:
		explosion_animation.scale = scale_vec * 0.3
	
	# La vie dépend de la taille
	life = 1
	
	randomRotationSpeed = randomGenerator.randi_range(-180, 180)
	if randomRotationSpeed == 0: 
		randomRotationSpeed = -1
	
	var base_speed = randomGenerator.randi_range(100, 200)
	speed = base_speed / (sqrt(randomSize)/2)
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var target = players[0].global_position
		direction = (target - global_position).normalized()

func _physics_process(delta: float) -> void:
	# Déplacement constant
	character_body.velocity = direction * speed
	character_body.move_and_slide()
	# Rotation manuelle
	character_body.rotation += deg_to_rad(randomRotationSpeed) * delta

# Fonction pour prendre des dégâts
func take_damage(amount: int) -> void:
	life -= amount
	explosion_sound.play()
	
	if life <= 0:
		emit_signal("meteor_destroyed")
		die()
		
# fonction pour faire mourir le meteor
func die() -> void:
	is_dying = true
	
	collider.set_deferred("disabled", true)
	area_collider.set_deferred("disabled", true)
	
	sprite.visible = false
	
	if explode_sound:
		explode_sound.play()
	
	if explosion_animation:
		explosion_animation.visible = true
		explosion_animation.play("explode")
		await explosion_animation.animation_finished
	else:
		await get_tree().create_timer(0.5).timeout
	
	queue_free()

# Fonction pour que le météore fasse des dégâts
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		
		queue_free()
