class_name FellowPlayer
extends GameController

var _parent_game_controller: GameController

func _init(parent_game_controller: GameController) -> void:
	assert(parent_game_controller)
	_parent_game_controller = parent_game_controller

	_credits = 0
	clock_ticked.connect(_on_clock_ticked)


func send_creep(creep_type: Variant):
	if _credits >= creep_type.PRICE:
		_parent_game_controller.receive_creep(creep_type)
		
		_credits -= creep_type.PRICE
		credits_changed.emit(_credits)
		
		_income += creep_type.PRICE * CREEP_INCOME_INCREASE
		income_changed.emit(_income)


func _on_clock_ticked(_remaining_time: int) -> void:
	if _credits >= CutterCreep.PRICE:
		send_creep(CutterCreep)
