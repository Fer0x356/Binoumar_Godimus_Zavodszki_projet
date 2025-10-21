extends CanvasLayer

func _ready() -> void:
	# Cache le menu au démarrage
	visible = false
	# Configure le mode de traitement pour que le script fonctionne même en pause
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# Détecte la touche Echap
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	# Inverse l'état de pause
	visible = true
	get_tree().paused = visible

func _on_btn_quit_button_down() -> void:
	# Retourne au menu principal
	get_tree().paused = false
	get_tree().change_scene_to_file("res://HUD/Menu/Menu.tscn")

func _on_btn_start_button_down() -> void:
	visible = false
	get_tree().paused = false
