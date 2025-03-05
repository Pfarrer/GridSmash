extends Control

func set_charge(value: float, capacity: float) -> void:
	$ProgressBar.max_value = capacity
	$ProgressBar.value = value


func show_grid_connection_warning():
	$NotConnectedSprite.show()


func hide_grid_connection_warning():
	$NotConnectedSprite.hide()
