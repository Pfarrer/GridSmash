extends PathFollow2D

@onready var creep_root = $"."

var game_controller: GameController
var creep: Creep

func _ready() -> void:
	assert(game_controller)
	assert(creep)
	
	creep.destroyed.connect(on_destroyed)


func _process(delta):
	self.progress += 100 * delta
	creep.position = self.position


func on_destroyed():
	creep_root.queue_free()


func on_map_area_exited(area: Area2D) -> void:
	if creep.health > 0:
		game_controller.creep_passed()
	creep_root.queue_free()
