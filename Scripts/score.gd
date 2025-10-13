extends Label

var score = 0
func _process(delta):
	self.text = str(score)

# incrémente le score de 1 à chaque météore touché avec un projectile
func _increment():
	score += 1
