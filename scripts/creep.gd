class_name Creep

signal destroyed()

var position = Vector2.ZERO
var health = 100

func handle_affect(affect_damage: int):
	health -= affect_damage
	
	if health <= 0:
		destroyed.emit()
