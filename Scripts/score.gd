extends Node2D

@export var ui_label: Label
@export var player: Node2D
var score = 0

func _ready() -> void:
	add_to_group("score_manager")
	
	# Connecter le signal perteHP du RigidBody2D enfant
	var player_body = player.get_node("RigidBody2D")
	if player_body and player_body.has_signal("perteHP"):
		player_body.perteHP.connect(_on_perte_hp)
	
	refresh_ui()

func refresh_ui():
	var player_body = player.get_node("RigidBody2D")
	var current_hp = player_body.life
	ui_label.text = "Score: " + str(score) + " | HP: " + str(current_hp)

func gain_score(intScore):
	score += intScore
	refresh_ui()

# Fonction appelée quand un météore est détruit
func _on_meteor_destroyed():
	gain_score(10)
	
func _on_perte_hp():
	refresh_ui()
