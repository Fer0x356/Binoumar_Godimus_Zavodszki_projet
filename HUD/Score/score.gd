extends Node2D

@export var ui_label: Label

var score = 0

func _ready() -> void:
	refresh_ui()
	
func refresh_ui():
	ui_label.text = "Score: " + str(score)
		
func gain_score(intScore):
	score += intScore
	refresh_ui()
	print("aaaa")
