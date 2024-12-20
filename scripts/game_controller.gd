class_name GameController

const INITIAL_LIVES = 20
const SECONDS_PER_ROUND = 15
const INITIAL_INCOME = 100
const INITIAL_CREDITS = 1000
const CREEP_PRICE = 100
const CREEP_INCOME_INCREASE = 10

signal lives_changed(remaining_lives: int)
signal round_changed(round_number: int)
signal clock_ticked(time_remaining_in_current_round: int)
signal income_changed(new_income: int)
signal credits_changed(new_credits: int)
signal creep_spawned()

var _lives: int = INITIAL_LIVES
var _round_number: int = 1
var _time_remaining_in_current_round: int = SECONDS_PER_ROUND
var _income: int = INITIAL_INCOME
var _credits: int = INITIAL_CREDITS

func send_creep():
	if _credits >= CREEP_PRICE:
		_credits -= CREEP_PRICE
		credits_changed.emit(_credits)
		
		_income += CREEP_INCOME_INCREASE
		income_changed.emit(_income)
		
		creep_spawned.emit()


func creep_passed():
	_lives -= 1
	lives_changed.emit(_lives)
	
	if _lives == 0:
		print("game over")


func _init(game_clock: Signal):
	game_clock.connect(_on_clock_tick)
	round_changed.connect(_on_round_changed)


func _on_clock_tick() -> void:
	if _time_remaining_in_current_round == 1:
		_round_number += 1
		round_changed.emit(_round_number)
		
		_time_remaining_in_current_round = SECONDS_PER_ROUND
	else:
		_time_remaining_in_current_round -= 1
	
	clock_ticked.emit(_time_remaining_in_current_round)


func _on_round_changed(round_number: int) -> void:
	_credits += _income
	credits_changed.emit(_credits)
