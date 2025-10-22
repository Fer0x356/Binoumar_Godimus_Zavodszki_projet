extends Marker2D

const Meteor = preload("res://Scene/Ennemies/meteor.tscn")

@export var spawn_distance_min: float = 1000  # Distance minimale du spawn
@export var spawn_distance_max: float = 1200  # Distance maximale du spawn
@export var spawn_interval_start: float = 1.0  # Intervalle de départ
@export var spawn_interval_min: float = 0.2  # Intervalle minimal (max difficulté)
@export var difficulty_increase_rate: float = 0.01  # Vitesse d'augmentation de difficulté

var current_spawn_interval: float
var elapsed_time: float = 0.0

# Référence au gestionnaire de score
var score_manager: Node2D

func _ready() -> void:
	current_spawn_interval = spawn_interval_start
	$MeteorTimer.wait_time = current_spawn_interval
	$MeteorTimer.timeout.connect(_on_MeteorTimer_timeout)
	
	# Trouver le gestionnaire de score dans la scène
	score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager == null:
		print("ATTENTION: Gestionnaire de score non trouvé!")

func _process(delta: float) -> void:
	# Augmenter progressivement la difficulté
	elapsed_time += delta
	
	# Réduire l'intervalle de spawn au fil du temps
	current_spawn_interval = max(
		spawn_interval_min,
		spawn_interval_start - (elapsed_time * difficulty_increase_rate)
	)
	
	$MeteorTimer.wait_time = current_spawn_interval

func _on_MeteorTimer_timeout() -> void:
	spawn()

func spawn() -> void:
	var meteor = Meteor.instantiate()
	
	# Trouver la position du joueur
	var player_position = Vector2.ZERO
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_position = players[0].global_position
	
	# Générer un angle aléatoire (0 à 360 degrés)
	var angle = randf() * TAU  # TAU = 2 * PI (un cercle complet)
	
	# Générer une distance aléatoire entre min et max
	var distance = randf_range(spawn_distance_min, spawn_distance_max)
	
	# Calculer la position de spawn en cercle autour du joueur
	var spawn_offset = Vector2(cos(angle), sin(angle)) * distance
	meteor.global_position = player_position + spawn_offset
	
	get_parent().add_child(meteor)
	
	# Connecter le signal du météore au gestionnaire de score
	if score_manager and score_manager.has_method("_on_meteor_destroyed"):
		# Vérifier si le météore a le signal
		if meteor.has_signal("meteor_destroyed"):
			meteor.meteor_destroyed.connect(score_manager._on_meteor_destroyed)
		else:
			print("ATTENTION: Le météore n'a pas de signal 'meteor_destroyed'!")
