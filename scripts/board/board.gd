class_name Board extends Node2D

signal total_points_changed(points: int)
signal round_points_changed(points: int)
signal multiplier_changed(points: int)
signal ball_ready

@export var gun: Gun


var total_points: int = 0:
	set(val):
		total_points = val
		total_points_changed.emit(total_points)
var round_points: int = 0:
	set(val):
		round_points = val
		round_points_changed.emit(round_points)
var total_multiplier: int = 0:
	set(val):
		total_multiplier = val
		multiplier_changed.emit(total_multiplier)
var highlighted_pegs: Array[Peg]

func _ready() -> void:
	gun.ball_spawned.connect(_on_ball_spawned)
	for child: Node in get_children():
		if child is Peg:
			child.peg_hit.connect(_on_peg_hit)
func _on_peg_hit(p: Peg) -> void:
	if p.has_hit:
		return
	if p.type == Peg.Type.MULTIPLIER:
		total_multiplier += p.multi
	else:
		round_points += p.points
	if not highlighted_pegs.has(p):
		highlighted_pegs.append(p)
func _on_ball_spawned(b: Ball) -> void:
	b.tree_exiting.connect(_on_ball_exited)
func _on_ball_exited() -> void:
	total_points += round_points
	round_points = 0
	await _clear_pegs()
	ball_ready.emit()
func _clear_pegs() -> void:
	for p in highlighted_pegs:
		if not is_instance_valid(p):
			continue
		p.queue_free()
		await get_tree().create_timer(0.1).timeout
	highlighted_pegs.clear()
