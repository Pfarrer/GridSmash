extends Panel

var game_controller: GameController
var energy_grid: EnergyGrid

func _ready() -> void:
	assert(game_controller)
	assert(energy_grid)
	
	energy_grid.energy_generation_changed.connect(_on_energy_generation_changed)
	energy_grid.energy_consumption_changed.connect(_on_energy_consumption_changed)
	energy_grid.energy_stored_changed.connect(_on_energy_stored_changed)

	_set_generation_bar_value(energy_grid.energy_generation())
	_set_consumption_bar_value(energy_grid.energy_consumption())
	_set_stored_bar_value(energy_grid.energy_stored())
	_update_bar_max_values()


func _on_energy_generation_changed(energy_generation: int) -> void:
	_set_generation_bar_value(energy_generation)
	_update_bar_max_values()


func _on_energy_consumption_changed(energy_consumption: int) -> void:
	_set_consumption_bar_value(energy_consumption)
	_update_bar_max_values()


func _on_energy_stored_changed(energy_stored: int) -> void:
	_set_stored_bar_value(energy_stored)
	_update_bar_max_values()


func _set_generation_bar_value(value: int) -> void:
	$HBoxContainer/GenerationBar.value = value
	$HBoxContainer/GenerationBar.tooltip_text = "Energy Generation: " + str(value) + "kW"


func _set_consumption_bar_value(value: int) -> void:
	$HBoxContainer/ConsumptionBar.value = value
	$HBoxContainer/ConsumptionBar.tooltip_text = "Energy Consumption: " + str(value) + "kW"


func _set_stored_bar_value(value: int) -> void:
	$HBoxContainer/StoredBar.value = value
	$HBoxContainer/StoredBar.tooltip_text = "Energy stored: " + str(value) + "kWs"


func _update_bar_max_values():
	var max_value = max($HBoxContainer/GenerationBar.value, $HBoxContainer/ConsumptionBar.value)
	$HBoxContainer/GenerationBar.max_value = max_value
	$HBoxContainer/GenerationBar.max_value = max_value
	$HBoxContainer/StoredBar.max_value = max_value
