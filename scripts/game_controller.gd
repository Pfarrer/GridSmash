class_name GameController


const SECONDS_PER_ROUND = 15
const INITIAL_INCOME = 100


signal round_changed(round_number: int)
signal clock_ticked(time_remaining_in_current_round: int)
signal income_changed(new_income: int)


var _round_number: int = 1
var _time_remaining_in_current_round: int = SECONDS_PER_ROUND


func _init(game_clock: Signal):
	game_clock.connect(_on_clock_tick)


func _on_clock_tick() -> void:
	if _time_remaining_in_current_round == 1:
		_round_number += 1
		round_changed.emit(_round_number)
		
		_time_remaining_in_current_round = SECONDS_PER_ROUND
	else:
		_time_remaining_in_current_round -= 1
	
	clock_ticked.emit(_time_remaining_in_current_round)
