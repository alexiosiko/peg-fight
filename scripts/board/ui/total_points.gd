extends Label

@export var board: Board

func _ready() -> void:
	board.total_points_changed.connect(_on_total_points_changed)
func _on_total_points_changed(p: int) -> void:
	text = str(p)
