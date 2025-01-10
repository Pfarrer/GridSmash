class_name AffectingStructure
extends Structure

signal creep_affected(creep: Creep)

var affect_radius = 80
var affect_interval_ms = 800
var affect_damage = 20

var affect_ready = false
var creeps_in_range: Array = []

func _init(pos: Vector2) -> void:
	super(pos, 20, 500)


func set_creep_in_range(creep: Creep) -> void:
	print("set_creep_in_range -- self: ", self, ", creep: ", creep)
	
	if creeps_in_range.has(creep):
		print_debug("Creep moved into range but was already in creeps_in_range list!", creep, self)
	else:
		creeps_in_range.append(creep)
		trigger_affect_if_possible()


func set_creep_out_of_range(creep: Creep) -> void:
	print("set_creep_out_of_range -- self: ", self, ", creep: ", creep)
	
	var idx = creeps_in_range.find(creep)
	if idx == -1:
		print_debug("Creep moved out of range but was not in creeps_in_range list!", creep, self)
	else:
		creeps_in_range.remove_at(idx)


func set_affect_ready() -> void:
	affect_ready = true
	trigger_affect_if_possible()


func trigger_affect_if_possible() -> void:
	if !is_floating && affect_ready && !creeps_in_range.is_empty():
		var target_creep = creeps_in_range.front()
		creep_affected.emit(target_creep)
		target_creep.handle_affect(affect_damage)
		affect_ready = false


func _to_string() -> String:
	return "AffectingStructure(%s, floating=%s)" % [position, is_floating]
