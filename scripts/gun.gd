class_name Gun extends Node2D

signal ball_spawned(b: Ball)

@export var ball_prefab: PackedScene
@export var release_point: Node2D
@export var ball_speed: float = 500
@export var ballls_container: Node
@export var board: Board

var rotation_speed: float = 50
var waiting: bool = false

func _ready() -> void:
	board.ball_ready.connect(func(): waiting = false)
func _physics_process(_delta: float) -> void:
	var target: Vector2 = get_global_mouse_position()
	rotation = global_position.angle_to_point(target)
	return
	#if Input.is_action_pressed("rotate_gun_left"):
		#rotation_degrees += 1 * delta * rotation_speed
	#elif Input.is_action_pressed("rotate_gun_right"):
		#rotation_degrees -= 1 * delta * rotation_speed
func _input(event: InputEvent) -> void:
	if not waiting && event.is_action_pressed("shoot"):
		waiting = true
		var direction = Vector2.from_angle(rotation)
		var pos: Vector2 = release_point.global_position
		shoot.rpc(pos, direction)

@rpc("call_local")
func shoot(pos: Vector2, dir: Vector2) -> void:
	var ball: Ball = ball_prefab.instantiate()
	ballls_container.add_child(ball)
	ball_spawned.emit(ball)

	ball.global_position = pos
	ball.linear_velocity = dir * ball_speed
