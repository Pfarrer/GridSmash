extends GridContainer

@onready var menu_root = $"../.."

func _ready() -> void:
	menu_root.game_controller.credits_changed.connect(_on_credits_changed)

	$GridNodeButton.connect("pressed", on_button_pressed.bind(GridNodeStructure))
	$GeneratorButton.connect("pressed", on_button_pressed.bind(GeneratorStructure))
	$BatteryButton.connect("pressed", on_button_pressed.bind(BatteryStructure))
	$LaserButton.connect("pressed", on_button_pressed.bind(LaserStructure))
	$ShockwaveButton.connect("pressed", on_button_pressed.bind(ShockwaveStructure))


func on_button_pressed(structure_type: Variant):
	menu_root.build_structure.emit(structure_type)


func _on_credits_changed(new_credits: int):
	$GridNodeButton.disabled = new_credits < GridNodeStructure.PRICE
	$GeneratorButton.disabled = new_credits < GeneratorStructure.PRICE
	$BatteryButton.disabled = new_credits < BatteryStructure.PRICE
	$LaserButton.disabled = new_credits < LaserStructure.PRICE
	$ShockwaveButton.disabled = new_credits < ShockwaveStructure.PRICE
