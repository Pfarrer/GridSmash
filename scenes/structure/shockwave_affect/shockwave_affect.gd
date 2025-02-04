extends Node2D

@onready var timer = $Timer

var structure: AffectingStructure

func _ready() -> void:
	assert(structure)


func _process(_delta: float) -> void:
	self.modulate.a = timer.time_left / timer.wait_time
	queue_redraw()


func _draw() -> void:
	var radius = structure.affect_radius * (1 - timer.time_left / timer.wait_time)
	draw_circle(Vector2.ZERO, radius, Color.GRAY, false, 4, true)


func on_timer_timeout() -> void:
	queue_free()
