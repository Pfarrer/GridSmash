extends GridContainer

@onready var menu_root = $"../.."

func _ready() -> void:
	$GridNodeButton.connect("pressed", on_button_pressed.bind(GridNodeStructure))
	$GeneratorButton.connect("pressed", on_button_pressed.bind(GeneratorStructure))
	$BatteryButton.connect("pressed", on_button_pressed.bind(BatteryStructure))
	$LaserButton.connect("pressed", on_button_pressed.bind(LaserStructure))
	$ShockwaveButton.connect("pressed", on_button_pressed.bind(ShockwaveStructure))


func on_button_pressed(structure_type: Variant):
	menu_root.build_structure.emit(structure_type)
