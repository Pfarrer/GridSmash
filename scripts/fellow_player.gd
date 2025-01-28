class_name FellowPlayer
extends GameController

func _init() -> void:
    _credits = 150

    clock_ticked.connect(_on_clock_ticked)


func _on_clock_ticked(_remaining_time: int) -> void:
    if _credits >= CREEP_PRICE:
        send_creep()
