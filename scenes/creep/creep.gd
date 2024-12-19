extends PathFollow2D


func _process(delta):
	self.progress += 100 * delta
