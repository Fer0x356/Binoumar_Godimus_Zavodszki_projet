extends CharacterBody2D

var collider: CollisionShape2D
var area_collider: CollisionShape2D
var sprite: Sprite2D

@onready var explosion_sound: AudioStreamPlayer2D = $"../ExplosionSound"
@onready var explode_sound = $ExplodeSound if has_node("ExplodeSound") else null

@onready var explosion_animation: AnimatedSprite2D = $ExplosionAnimation if has_node("ExplosionAnimation") else null

var is_dying: bool = false

var randomGenerator := RandomNumberGenerator.new()
var randomSize: float
var randomRotationSpeed: float

var life: int
var speed: float
var direction: Vector2

func _ready() -> void:
	collider = $CollisionShape2D
	area_collider = $Area2D/CollisionShape2D
	sprite = $Sprite2D
	
	collision_layer = 2
	collision_mask = 1
	
	randomGenerator.randomize()
	randomSize = randomGenerator.randi_range(2, 8)

	# change la taille du meteor
	var scale_vec = Vector2(randomSize, randomSize)
	collider.scale = scale_vec
	area_collider.scale = scale_vec
	sprite.scale = scale_vec
	
	# change la taille de l'explosion en fonction de la taille du meteor (0.3 car sinon c'est trop grand)
	if explosion_animation:
		explosion_animation.scale = scale_vec * 0.3
	
	life = 1
	
	# change la vitesse de rotation random
	randomRotationSpeed = randomGenerator.randi_range(-180, 180)
	if randomRotationSpeed == 0: 
		randomRotationSpeed = -1
	
	# et sa taille influence sa vitesse
	var base_speed = randomGenerator.randi_range(100, 200)
	speed = base_speed / (sqrt(randomSize)/2)
	
	# vise le joueur
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var target = players[0].global_position
		direction = (target - global_position).normalized()

func _physics_process(delta: float) -> void:
	if is_dying:
		return
		
	velocity = direction * speed
	move_and_slide()

	rotation += deg_to_rad(randomRotationSpeed) * delta

func take_damage(amount: int) -> void:
	if is_dying:
		return
		
	life -= amount
	explosion_sound.play()
	
	if life <= 0:
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

# collision avec le joueur
func _on_body_entered(body: Node) -> void:
	if is_dying:
		return
		
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		die()
