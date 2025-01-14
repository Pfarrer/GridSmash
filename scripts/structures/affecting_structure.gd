class_name AffectingStructure
extends Structure

signal creep_affected(creep: Creep)

var affect_radius = 80
var affect_interval_ms = 500
var affect_damage = 20
var affect_energy_use = 10

var affect_interval_ready = false
var creeps_in_range: Array = []

func _init(pos: Vector2) -> void:
	super(pos, 20, 500)
	energy_capacity = 50
	energy_consumption = 20


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
	affect_interval_ready = true
	trigger_affect_if_possible()


func add_energy_charge(charge: float) -> void:
	super.add_energy_charge(charge)
	trigger_affect_if_possible()


func trigger_affect_if_possible() -> void:
	if !is_floating && affect_interval_ready && energy_charge >= affect_energy_use && !creeps_in_range.is_empty():
		var target_creep = creeps_in_range.front()
		creep_affected.emit(target_creep)
		target_creep.handle_affect(affect_damage)
		affect_interval_ready = false
		energy_charge -= affect_energy_use


func _to_string() -> String:
	return "AffectingStructure(%s, floating=%s)" % [position, is_floating]
