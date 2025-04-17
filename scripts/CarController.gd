extends RigidBody3D

const POWER = 70000
const BASE_TURN_TORQUE = 40000.0
const MAX_TURN_SCALE_SPEED = 40.0
const MIN_SPEED_TO_TURN = 0.0

var is_driving := false

func _physics_process(delta):
	if not is_driving:
		return

	gas_brake()
	turn(delta)

func gas_brake():
	var z = 0
	if Input.is_action_pressed("up"):
		z -= 1
	if Input.is_action_pressed("down"):
		z += 1

	apply_central_force(transform.basis.z * z * POWER)

func turn(delta):
	var x = 0
	if Input.is_action_pressed("left"):
		x -= 1
	if Input.is_action_pressed("right"):
		x += 1

	if x == 0:
		return

	var forward_velocity = linear_velocity.dot(transform.basis.z)

	if abs(forward_velocity) < MIN_SPEED_TO_TURN:
		return

	# The lower the speed, the higher the turn boost — inverse of speed
	var inverse_speed_ratio = 1.0 - clamp(abs(forward_velocity) / MAX_TURN_SCALE_SPEED, 0.0, 1.0)
	var turn_boost = 1.0 + inverse_speed_ratio * 2.0  # Boost turns 1x–3x stronger when slow

	var direction = sign(forward_velocity)
	var torque_amount = x * direction * BASE_TURN_TORQUE * turn_boost

	apply_torque(Vector3.UP * torque_amount)

func set_is_driving(value: bool) -> void:
	is_driving = value
