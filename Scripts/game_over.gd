extends Control

@export var total_score: Script
@export var score_label:Label

func _ready():
	# Display the final score from Global singleton
	if has_node("/root/Global"):
		var final_score = get_node("/root/Global").get_score()
		score_label.text = "Your score is: " + str(final_score)

func _process(delta):
	pass

func _on_btn_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scene/Menu/Menu.tscn")


func _on_btn_quit_button_down() -> void:
	get_tree().quit()
