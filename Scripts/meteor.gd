extends RigidBody2D

# Déclaration des variables
# Variables des enfants du noeud RigidBody2D
var collider: CollisionShape2D
var sprite: Sprite2D

# Générateur de nombre aléatoire pour la taille des météores
var randomGenerator := RandomNumberGenerator.new()
var randomSize: float
var randomRotationSpeed: float

func _ready() -> void:
	# Récupération des enfants
	collider = $CollisionShape2D
	sprite = $Sprite2D
	
	# Initialisation du générateur
	randomGenerator.randomize()
	# Tirage d'un nombre entre 2 et 8
	randomSize = randomGenerator.randi_range(2, 8)

	# Taille aléatoire
	var scale_vec = Vector2(randomSize, randomSize)
	collider.scale = scale_vec
	sprite.scale = scale_vec
	
	# Velocité aléatoire
	randomRotationSpeed = randomGenerator.randi_range(-5, 5)
	
	# Pour éviter d'avoir une rotation à 0
	if (randomRotationSpeed == 0): 
		randomRotationSpeed = -1
	
	# Vitesse de base
	var base_speed = randomGenerator.randi_range(100, 200)
	
	# Plus le météore est gros, plus il est lent
	var speed = base_speed / sqrt(randomSize) # Racine de la taille pour éviter que les gros soient trop lents
	
	# Direction vers le centre
	var target = Vector2(960, 540)
	var direction = (target - global_position).normalized()
	# Vitesse finale
	linear_velocity = direction * speed

func _process(delta: float) -> void:
	angular_velocity = randomRotationSpeed # Tourne à l'infini à une vitesse et à un sens aléatoire
