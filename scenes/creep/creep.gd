extends PathFollow2D

var creep: Creep

func _ready() -> void:
	assert(creep)
	
	creep.destroyed.connect(on_destroyed)


func _process(delta: float):
	progress += creep.speed * delta
	creep.position = position


func on_destroyed(_creep: Creep):
	queue_free()
