@tool
class_name Ball extends RigidBody2D

signal stuck_cleared

enum Type { NORMAL, MULTIPLIER, POWER }

var type: Type

const STUCK_TIME := 1.5          # seconds of no real movement before acting
const STUCK_DISTANCE := 12.0     # must move at least this far within the window
const CHECK_INTERVAL := 0.25

var _check_timer := 0.0
var _stuck_timer := 0.0
var _last_check_pos := Vector2.ZERO
var _touching_pegs: Array[Peg] = []

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_last_check_pos = global_position

func _on_body_entered(body: Node) -> void:
	if body is Peg:
		body.hit(linear_velocity)
		if not _touching_pegs.has(body):
			_touching_pegs.append(body)

	if body.name == "OutOfBounds":
		queue_free()

func _on_body_exited(body: Node) -> void:
	if body is Peg:
		_touching_pegs.erase(body)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_check_timer += delta
	if _check_timer < CHECK_INTERVAL:
		return
	_check_timer = 0.0

	var moved := global_position.distance_to(_last_check_pos)
	_last_check_pos = global_position

	if moved < STUCK_DISTANCE:
		_stuck_timer += CHECK_INTERVAL
	else:
		_stuck_timer = 0.0

	if _stuck_timer >= STUCK_TIME:
		_stuck_timer = 0.0
		_free_stuck_ball()

func _free_stuck_ball() -> void:
	# Remove the pegs we're resting on (what Peggle does)
	var removed := false
	for peg in _touching_pegs.duplicate():
		if is_instance_valid(peg):
			peg.hit(linear_velocity)
			peg.queue_free()
			removed = true
	_touching_pegs.clear()

	# Fallback: not touching a peg (e.g. wedged between walls), nudge it
	if not removed:
		apply_central_impulse(Vector2(randf_range(-1.0, 1.0), -1.0).normalized() * 300.0)

	stuck_cleared.emit()
