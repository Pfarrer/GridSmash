extends Panel

var game_controller: GameController
var energy_grid: EnergyGrid

func _ready() -> void:
	assert(game_controller)
	assert(energy_grid)
	
	energy_grid.energy_generation_max_changed.connect(_set_generation_bar_max_value)
	energy_grid.energy_consumption_max_changed.connect(_set_consumption_bar_max_value)
	energy_grid.energy_capacity_max_changed.connect(_set_capacity_bar_max_value)

	_set_generation_bar_max_value(energy_grid.energy_generation_max())
	_set_consumption_bar_max_value(energy_grid.energy_consumption_max())
	_set_capacity_bar_max_value(energy_grid.energy_capacity_max())


func _process(_delta: float) -> void:
	_set_generation_bar_value(energy_grid.energy_flow.current_energy_flow)
	_set_consumption_bar_value(energy_grid.energy_flow.current_energy_flow)
	_set_capacity_bar_value(0)


func _set_generation_bar_max_value(max_value: int) -> void:
	$HBoxContainer/GenerationBar.max_value = max_value


func _set_consumption_bar_max_value(max_value: int) -> void:
	$HBoxContainer/ConsumptionBar.max_value = max_value


func _set_capacity_bar_max_value(max_value: int) -> void:
	$HBoxContainer/CapacityBar.max_value = max_value


func _set_generation_bar_value(value: int) -> void:
	$HBoxContainer/GenerationBar.value = value
	$HBoxContainer/GenerationBar.tooltip_text = "Energy generation: " + str(value) + "kW"


func _set_consumption_bar_value(value: int) -> void:
	$HBoxContainer/ConsumptionBar.value = value
	$HBoxContainer/ConsumptionBar.tooltip_text = "Energy consumption: " + str(value) + "kW"


func _set_capacity_bar_value(value: int) -> void:
	$HBoxContainer/CapacityBar.value = value
	$HBoxContainer/CapacityBar.tooltip_text = "Energy stored: " + str(value) + "kWs"
