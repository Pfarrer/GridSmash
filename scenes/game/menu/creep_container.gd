extends GridContainer

@onready var menu_root = $"../.."

func _ready() -> void:
	$StrongCreepButton.connect("pressed", on_button_pressed.bind(StrongCreep))
	$CutterCreepButton.connect("pressed", on_button_pressed.bind(CutterCreep))


func on_button_pressed(creep_type: Variant):
	menu_root.game_controller.send_creep(creep_type)
