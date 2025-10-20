extends Control

@onready var menu = preload("res://HUD/Menu/Menu.tscn")

func _on_btn_start_button_down() -> void:
	get_tree().change_scene_to_packed(menu)	


func _on_btn_quit_button_down() -> void:
	get_tree().quit()
