extends Node2D

@export var ui_label: Label
var score = 0

func _ready() -> void:
	add_to_group("score_manager")
	refresh_ui()

func refresh_ui():
	ui_label.text = "Score: " + str(score)

func gain_score(intScore):
	score += intScore
	refresh_ui()

# Fonction appelée quand un météore est détruit
func _on_meteor_destroyed():
	gain_score(10)
