extends PathFollow2D

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)


func _process(delta):
	self.progress += 100 * delta


func _on_area_exited(area: Area2D) -> void:
	game_controller.creep_passed()
	get_node(".").queue_free()
