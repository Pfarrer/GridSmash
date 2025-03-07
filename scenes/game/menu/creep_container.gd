extends GridContainer

@onready var menu_root = $"../.."

func _ready() -> void:
	menu_root.game_controller.credits_changed.connect(_on_credits_changed)

	$StrongCreepButton.connect("pressed", on_button_pressed.bind(StrongCreep))
	$CutterCreepButton.connect("pressed", on_button_pressed.bind(CutterCreep))


func on_button_pressed(creep_type: Variant):
	menu_root.game_controller.send_creep(creep_type)


func _on_credits_changed(new_credits: int) -> void:
	$StrongCreepButton.disabled = new_credits < StrongCreep.PRICE
	$CutterCreepButton.disabled = new_credits < CutterCreep.PRICE
