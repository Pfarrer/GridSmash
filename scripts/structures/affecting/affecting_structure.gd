class_name AffectingStructure
extends Structure

signal creeps_affected(creeps: Array)

var affect_radius: int
var affect_damage: int
var affect_energy_use: int

var creeps_in_range: Array = []

func _init(pos: Vector2, radius: int, price: int, _affect_radius: int, _affect_damage: int, _affect_energy_use: int) -> void:
	super(pos, radius, price)
	energy_consumption = _affect_energy_use
	energy_capacity = _affect_energy_use

	affect_radius = _affect_radius
	affect_damage = _affect_damage
	affect_energy_use = _affect_energy_use


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


func add_energy_charge(charge: float) -> void:
	super.add_energy_charge(charge)
	trigger_affect_if_possible()


func trigger_affect_if_possible() -> void:
	if !is_floating && energy_charge >= affect_energy_use && !creeps_in_range.is_empty():
		energy_charge -= affect_energy_use
		_affect_creeps()


func _affect_creeps() -> void:
	print_debug("Method must be overwritten by concrete subclasses!")


func _to_string() -> String:
	return "AffectingStructure(%s, floating=%s)" % [position, is_floating]
