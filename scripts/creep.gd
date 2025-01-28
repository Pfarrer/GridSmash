class_name Creep

# A creep is also destroyed when it passes through the entire map and steals a live from the player.
signal destroyed(creep: Creep)

var speed = 100
var position = Vector2.ZERO
var health = 50

func handle_affect(affect_damage: int):
	health -= affect_damage
	
	if health <= 0:
		health = 0
		self.destroyed.emit(self)


func _to_string() -> String:
	return "Creep(%s, health=%s)" % [position, health]
