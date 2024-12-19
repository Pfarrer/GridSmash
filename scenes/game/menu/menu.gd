extends MarginContainer


@onready var roundNumberLabel: Label = $VBoxContainer/GridContainer/RoundNumber
@onready var nextRoundInLabel: Label = $VBoxContainer/GridContainer/NextRoundIn
@onready var incomeLabel: Label = $VBoxContainer/GridContainer/Income
@onready var creditsLabel: Label = $VBoxContainer/GridContainer/Credits


var game_controller: GameController


func _ready() -> void:
	assert(game_controller)
	
	roundNumberLabel.text = "1"
	nextRoundInLabel.text = str(GameController.SECONDS_PER_ROUND)
	incomeLabel.text = str(GameController.INITIAL_INCOME)
	creditsLabel.text = str(GameController.INITIAL_CREDITS)
	
	game_controller.round_changed.connect(_on_round_changed)
	game_controller.clock_ticked.connect(_on_clock_ticked)
	game_controller.income_changed.connect(_on_income_changed)
	game_controller.credits_changed.connect(_on_credits_changed)


func _on_round_changed(round_number: int) -> void:
	roundNumberLabel.text = str(round_number)


func _on_clock_ticked(time_remaining_in_round: int):
	nextRoundInLabel.text = str(time_remaining_in_round)


func _on_income_changed(new_income: int):
	incomeLabel.text = str(new_income)


func _on_credits_changed(new_credits: int):
	creditsLabel.text = str(new_credits)


func _on_creep_button_pressed() -> void:
	game_controller.send_creep()
