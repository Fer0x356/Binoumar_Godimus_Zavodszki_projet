extends AudioStreamPlayer2D

# Liste des musiques disponibles
var music_tracks: Array[AudioStream] = []
var current_track_index: int = -1
var rng := RandomNumberGenerator.new()

func _ready():
	# Charger toutes les musiques du dossier bgMusic
	music_tracks = [
		preload("res://Sounds/bgMusic/asgore.wav"),
		preload("res://Sounds/bgMusic/persona1.wav"),
		preload("res://Sounds/bgMusic/persona2.wav")
	]
	
	rng.randomize()
	
	finished.connect(_on_music_finished)
	
	play_random_track()

func play_random_track() -> void:
	if music_tracks.is_empty():
		push_error("Aucune musique disponible!")
		return
	
	# Choisir un index random différent 
	var new_index: int
	if music_tracks.size() > 1:
		# Éviter de fois de suite même musique
		new_index = rng.randi_range(0, music_tracks.size() - 1)
		while new_index == current_track_index and music_tracks.size() > 1:
			new_index = rng.randi_range(0, music_tracks.size() - 1)
	else:
		new_index = 0
	
	current_track_index = new_index
	stream = music_tracks[current_track_index]
	play()
	
func _on_music_finished() -> void:
	# Quand une musique se termine lancer une autre random
	play_random_track()
