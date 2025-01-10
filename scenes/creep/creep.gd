extends PathFollow2D

var creep: Creep

func _ready() -> void:
	assert(creep)
	
	creep.destroyed.connect(on_destroyed)


func _process(delta: float):
	self.progress += 100 * delta
	creep.position = self.position


func on_destroyed(_creep: Creep):
	queue_free()
