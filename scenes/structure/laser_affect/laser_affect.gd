extends Node2D

@onready var timer = $Timer

var structure: Structure
var creep: Creep

func _ready() -> void:
	assert(structure)
	assert(creep)


func _process(delta: float) -> void:
	self.modulate.a = timer.time_left / timer.wait_time


func _draw() -> void:
	draw_line(Vector2.ZERO, creep.position - structure.position, Color.RED, 2, true)


func on_timer_timeout() -> void:
	queue_free()
