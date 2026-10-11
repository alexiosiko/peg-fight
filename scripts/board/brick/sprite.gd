extends Sprite2D

var peg: Peg:
	get(): 
		return owner as Peg
func _ready() -> void:
	material = material.duplicate()
	match owner.type:
		Peg.Type.MULTIPLIER:
			self_modulate = Color.GREEN
	peg.peg_hit.connect(_on_peg_hit)
func _on_peg_hit(_b: Peg) -> void:
	(material as ShaderMaterial).set_shader_parameter("highlight", true)
