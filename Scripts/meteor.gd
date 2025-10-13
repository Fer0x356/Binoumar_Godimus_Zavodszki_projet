extends CharacterBody2D

var collider: CollisionShape2D
var area_collider: CollisionShape2D
var sprite: Sprite2D

# Sons (à configurer dans la scène)
@onready var explosion_sound: AudioStreamPlayer2D = $"../ExplosionSound"
@onready var explode_sound = $ExplodeSound if has_node("ExplodeSound") else null

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
	
	# Configuration des collisions : les météores ne se bloquent pas entre eux
	collision_layer = 2  # Les météores sont sur la layer 2
	collision_mask = 1   # Les météores détectent seulement la layer 1 (joueur, murs, etc.)
	
	randomGenerator.randomize()
	randomSize = randomGenerator.randi_range(2, 8)

	var scale_vec = Vector2(randomSize, randomSize)
	collider.scale = scale_vec
	area_collider.scale = scale_vec  # Ajout de cette ligne !
	sprite.scale = scale_vec
	
	# La vie dépend de la taille
	life = 1

	area_collider.scale = scale_vec  # Ajout de cette ligne !
	sprite.scale = scale_vec
	
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
	velocity = direction * speed
	move_and_slide()

	# Rotation manuelle
	rotation += deg_to_rad(randomRotationSpeed) * delta

# Fonction pour prendre des dégâts
func take_damage(amount: int) -> void:
	life -= amount
	explosion_sound.play()
	
	if life <= 0:
		# Jouer le son d'explosion
		if explode_sound:
			explode_sound.play()
			# Attendre que le son finisse avant de détruire
			await explode_sound.finished
		queue_free()

# Fonction pour que le météore fasse des dégâts
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
