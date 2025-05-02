extends CharacterBody2D

const SPEED = 1000

func _physics_process(delta):
	if not is_multiplayer_authority():
		return

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()

	rpc("sync_position", global_position)

@rpc("unreliable")
func sync_position(pos):
	global_position = pos
