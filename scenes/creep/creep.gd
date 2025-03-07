extends Node2D

var creep: Creep

func _ready() -> void:
	assert(creep)
	_set_creep_specific_asset()
	$HealthBar.max_value = creep.health

	creep.health_changed.connect(_on_health_changed)
	creep.destroyed.connect(on_destroyed)


func _process(delta: float):
	self.progress += creep.speed * delta
	creep.position = position


func on_destroyed(_creep: Creep):
	queue_free()


func _on_creep_area_area_entered(area: Area2D) -> void:
	if area is GridConnectionArea:
		creep.on_grid_connection_touch(area.connection)


func _set_creep_specific_asset():
	if creep is StrongCreep:
		$Sprites/StrongCreepSprite.show()
	elif creep is CutterCreep:
		$Sprites/CutterCreepSprite.show()


func _on_health_changed(health: float):
	$HealthBar.value = health
	$HealthBar.show()
