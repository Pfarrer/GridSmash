extends Control

func set_charge(value: int, capacity: int):
	$ProgressBar.max_value = capacity
	$ProgressBar.value = value


func show_grid_connection_warning():
	$NotConnectedSprite.show()


func hide_grid_connection_warning():
	$NotConnectedSprite.hide()
