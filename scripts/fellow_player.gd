class_name FellowPlayer
extends GameController

var _parent_game_controller: GameController

func _init(parent_game_controller: GameController) -> void:
	assert(parent_game_controller)
	_parent_game_controller = parent_game_controller

	_credits = 0
	clock_ticked.connect(_on_clock_ticked)


func send_creep():
	if _credits >= CREEP_PRICE:
		_parent_game_controller.receive_creep(Creep.new())
		
		_credits -= CREEP_PRICE
		credits_changed.emit(_credits)
		
		_income += CREEP_INCOME_INCREASE
		income_changed.emit(_income)


func _on_clock_ticked(_remaining_time: int) -> void:
	if _credits >= CREEP_PRICE:
		send_creep()
