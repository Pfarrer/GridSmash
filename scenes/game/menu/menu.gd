extends VBoxContainer


@export_node_path("Timer") var roundTimer: NodePath


@onready var roundNumberLabel: Label = $GridContainer/RoundNumber
@onready var nextRoundInLabel: Label = $GridContainer/NextRoundIn


func _ready() -> void:
	roundNumberLabel.text = "1"
	get_node(roundTimer).timeout.connect(_increment_roundNumber)


func _process(delta: float) -> void:
	_update_nextRoundIn()


func _increment_roundNumber() -> void:
	roundNumberLabel.text = str(int(roundNumberLabel.text) + 1)


func _update_nextRoundIn():
	nextRoundInLabel.text = str(ceil((get_node(roundTimer) as Timer).time_left))
