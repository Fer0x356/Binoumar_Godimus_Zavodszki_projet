extends Control
@onready var game = preload("res://main.tscn")

func _on_btn_start_button_down() -> void:
	get_tree().change_scene_to_packed(game)	


func _on_btn_quit_button_down() -> void:
	get_tree().quit()
