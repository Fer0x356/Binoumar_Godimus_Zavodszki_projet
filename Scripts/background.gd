extends ParallaxBackground

var speed : float = 100  # pixels par secondes

func _process(delta):
	scroll_base_offset.x -= speed * delta
