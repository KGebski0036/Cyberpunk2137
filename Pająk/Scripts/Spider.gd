extends KinematicBody

var direction = Vector3.BACK
var velocity = Vector3.ZERO
var strafe_dir = Vector3.ZERO


var vertical_velocity = 0
var gravity = 20

var movement_speed = 0
var walk_speed = 20
var run_speed = 30
var acceleration = 6

func _input(event):
		if event.is_action_released("sprint"):
				velocity = direction

func _physics_process(delta):
	
	if !$roll_timer.is_stopped():
		acceleration = 3.5
	else:
		acceleration = 5
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	if Input.is_action_pressed("forward") ||  Input.is_action_pressed("backward") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		
		direction = Vector3(Input.get_action_strength("right") - Input.get_action_strength("left"),
					0,
					Input.get_action_strength("backward") - Input.get_action_strength("forward"))

		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
		movement_speed = 0
		strafe_dir = Vector3.ZERO
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)

	move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
