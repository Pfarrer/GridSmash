extends VBoxContainer


@onready var roundNumberLabel: Label = $GridContainer/RoundNumber
@onready var nextRoundInLabel: Label = $GridContainer/NextRoundIn
@onready var incomeLabel: Label = $GridContainer/Income


var game_controller: GameController


func _ready() -> void:
	assert(game_controller)
	
	roundNumberLabel.text = "1"
	nextRoundInLabel.text = str(GameController.SECONDS_PER_ROUND)
	incomeLabel.text = str(GameController.INITIAL_INCOME)
	
	game_controller.round_changed.connect(_on_next_round)
	game_controller.clock_ticked.connect(_on_clock_tick)
	game_controller.income_changed.connect(_on_clock_tick)


func _on_next_round(round_number: int) -> void:
	roundNumberLabel.text = str(round_number)


func _on_clock_tick(time_remaining_in_round: int):
	nextRoundInLabel.text = str(time_remaining_in_round)
