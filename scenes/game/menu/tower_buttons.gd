extends GridContainer

@onready var menu_root = $"../.."

func _ready() -> void:
	$GridNodeButton.connect("pressed", on_button_pressed.bind(GridNodeStructure))
	$LaserTowerButton.connect("pressed", on_button_pressed.bind(AffectingStructure))


func on_button_pressed(structure_type: Variant):
	menu_root.build_structure.emit(structure_type)
