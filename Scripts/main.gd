extends Node2D

var pause_menu

func _ready():
	var scene = preload("res://HUD/Menu/Pause.tscn")
	pause_menu = scene.instantiate()
	add_child(pause_menu)

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Échap par défaut
		if get_tree().paused:
			pause_menu.close_menu()
		else:
			pause_menu.open_menu()
