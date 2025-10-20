extends Control

@onready var pause_menu = $Pause

func _ready():
	visible = false  # caché au départ
	get_tree().paused = false

func open_menu():
	visible = true
	get_tree().paused = true
	# Pour que le menu réponde aux clics même en pause :
	process_mode = Node.PROCESS_MODE_ALWAYS

func close_menu():
	visible = false
	get_tree().paused = false
