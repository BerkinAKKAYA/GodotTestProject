extends Area3D

signal request_camera_target_change(new_target: Node3D)

@onready var car = $".."
@onready var player = $"../../Player"

var player_inside := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _unhandled_input(event):
	if Input.is_action_just_pressed("drive"):
		if car.is_driving:
			emit_signal("request_camera_target_change", player, Vector3(0, 2, 4))
			car.set_is_driving(false)
			player.set_is_driving(false)

			var exit_offset = Vector3(-2, 0, 0)
			player.global_position = self.global_position + exit_offset
		elif player_inside:
			emit_signal("request_camera_target_change", self, Vector3(0, 3, 7))
			car.set_is_driving(true)
			player.set_is_driving(true)
	

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
