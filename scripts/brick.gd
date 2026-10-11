class_name Peg extends StaticBody2D

signal peg_hit(b: Peg)

enum Type {
	REGULAR,
	MULTIPLIER,
	BOUNCY
}

@export var multi: int
@export var sprite: Sprite2D
@export var type: Type
@export var label: Label

var points: int = 5
var highlight: bool = false
var has_hit: bool = false
var hit_count: int = 0

func _ready() -> void:
	label.hide()
	match type:
		Type.MULTIPLIER: 
			label.show()
		Type.BOUNCY:
			pass
			
func hit(linear_velocity: Vector2) -> void:
	peg_hit.emit(self)
	has_hit = true
	sprite.position -= linear_velocity.normalized() * 5
	highlight = true

		
func _physics_process(delta: float) -> void:
	sprite.position = sprite.position.lerp(Vector2.ZERO, delta * 5)
