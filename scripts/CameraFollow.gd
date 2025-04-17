extends Node3D

var speed := 6.0
var rotationSpeed := 30.0

var target: Node3D
var offset := Vector3(0, 2, 4)

func _ready():
	target = $"../Player"

func _process(delta):
	if not target:
		return

	_update_position(delta)
	_update_rotation(delta)

func _update_position(delta):
	var desired_position = target.global_transform.origin + target.global_transform.basis * offset
	global_position = global_position.lerp(desired_position, speed * delta)

func _update_rotation(delta):
	var direction_to_target = (target.global_transform.origin - global_transform.origin).normalized()
	var current_basis = global_transform.basis
	var target_basis = Basis.looking_at(direction_to_target, Vector3.UP)
	global_transform.basis = current_basis.slerp(target_basis, rotationSpeed * delta)

func _on_area_3d_request_camera_target_change(new_target, new_offset):
	target = new_target
	offset = new_offset
