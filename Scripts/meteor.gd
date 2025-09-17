extends RigidBody2D

# Déclaration des variables
# Variables des enfants du noeud RigidBody2D
var collider: CollisionShape2D
var sprite: Sprite2D

# Générateur de nombre aléatoire pour la taille des météores
var randomGenerator := RandomNumberGenerator.new()
var randomSize: float
var randomScale: float

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
	randomScale = randomGenerator.randi_range(-5, 5)
	
	if (randomScale == 0): # Pour éviter d'avoir une rotation à 0
		randomScale = -1
		
	# Direction vers le centre (la moitié de la taille de l’écran)
	var target = Vector2(960, 540) # centre scene (à remplacer par la pos du joueur plus tard)
	var direction = (target - global_position).normalized()
	
	# Appliquer une vitesse linéaire vers le centre
	var speed = randomGenerator.randi_range(100, 200) # vitesse aléatoire en pixels/sec
	linear_velocity = direction * speed

func _process(delta: float) -> void:
	angular_velocity = randomScale # Tourne à l'infini à une vitesse et à un sens aléatoire
