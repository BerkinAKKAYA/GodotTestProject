extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const MOUSE_SENSITIVITY = 0.004
const JUMP_STRENGTH = 10
const GRAVITY_STRENGTH = 30

@onready var collider = $CollisionShape3D

var is_driving = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	mouse_rotation(event)

func _physics_process(delta: float):
	if is_driving:
		return

	jump_and_gravity(delta)
	movement()

func jump_and_gravity(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY_STRENGTH * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_STRENGTH

func movement():
	var direction = get_direction()
	if Input.is_action_pressed("sprint"):
		velocity.x = direction.x * SPRINT_SPEED
		velocity.z = direction.z * SPRINT_SPEED
	else:
		velocity.x = direction.x * WALK_SPEED
		velocity.z = direction.z * WALK_SPEED

	move_and_slide()

func get_direction() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = Vector3(input_dir.x, 0, input_dir.y)

	direction = global_transform.basis * direction
	direction.y = 0
	direction = direction.normalized()

	return direction

func mouse_rotation(event):
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

func set_is_driving(value: bool):
	is_driving = value
	visible = !is_driving
	collider.disabled = is_driving
	
