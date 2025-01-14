extends MarginContainer

signal build_structure(structure_type: Variant)

@onready var lives_remaining_label: Label = $VBoxContainer/GameDetailsContainer/LivesRemaining
@onready var round_number_label: Label = $VBoxContainer/GameDetailsContainer/RoundNumber
@onready var next_round_in_label: Label = $VBoxContainer/GameDetailsContainer/NextRoundIn
@onready var income_label: Label = $VBoxContainer/GameDetailsContainer/Income
@onready var credits_label: Label = $VBoxContainer/GameDetailsContainer/Credits
@onready var grid_statuses_container = $VBoxContainer/GridStatusesContainer

var game_controller: GameController

func _ready() -> void:
	assert(game_controller)
	
	lives_remaining_label.text = str(GameController.INITIAL_LIVES)
	round_number_label.text = "1"
	next_round_in_label.text = str(GameController.SECONDS_PER_ROUND)
	income_label.text = str(GameController.INITIAL_INCOME)
	credits_label.text = str(GameController.INITIAL_CREDITS)
	
	game_controller.lives_changed.connect(_on_lives_changed)
	game_controller.round_changed.connect(_on_round_changed)
	game_controller.clock_ticked.connect(_on_clock_ticked)
	game_controller.income_changed.connect(_on_income_changed)
	game_controller.credits_changed.connect(_on_credits_changed)
	game_controller.energy_grids.grid_added.connect(_on_energy_grid_added)
	game_controller.energy_grids.grid_removed.connect(_on_energy_grid_removed)


func _on_lives_changed(lives_remaining: int) -> void:
	lives_remaining_label.text = str(lives_remaining)


func _on_round_changed(round_number: int) -> void:
	round_number_label.text = str(round_number)


func _on_clock_ticked(time_remaining_in_round: int):
	next_round_in_label.text = str(time_remaining_in_round)


func _on_income_changed(new_income: int):
	income_label.text = str(new_income)


func _on_credits_changed(new_credits: int):
	credits_label.text = str(new_credits)


func _on_creep_button_pressed() -> void:
	game_controller.send_creep()


func _on_energy_grid_added(energy_grid: EnergyGrid):
	var grid_status = preload("res://scenes/game/menu/grid_status/grid_status.tscn").instantiate()
	grid_status.game_controller = game_controller
	grid_status.energy_grid = energy_grid
	grid_statuses_container.add_child(grid_status)


func _on_energy_grid_removed(energy_grid: EnergyGrid):
	for child in grid_statuses_container.get_children():
		if child.energy_grid == energy_grid:
			child.queue_free()
			break
