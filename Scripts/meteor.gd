extends RigidBody2D

# Déclaration des variables
var collider: CollisionShape2D
var sprite: Sprite2D

# Générateur de nombre aléatoire pour la taille des météores
var randomGenerator := RandomNumberGenerator.new()
var random: float

func _ready() -> void:
	# Récupération des enfants
	collider = $CollisionShape2D
	sprite = $Sprite2D
	
	# Initialisation du random
	randomGenerator.randomize()
	# Tirage d'un nombre entre 4 et 10
	random = randomGenerator.randi_range(2, 8)

	# Taille aléatoire
	var scale_vec = Vector2(random, random)
	collider.scale = scale_vec
	sprite.scale = scale_vec
	
	
	
	print(random)

func _process(delta: float) -> void:
	angular_velocity = 5.0 # Tourne à l'infini
