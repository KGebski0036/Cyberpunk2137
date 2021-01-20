extends KinematicBody

var direction = Vector3.BACK
var velocity = Vector3.ZERO

var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO

var speed = 0
var walk_speed = 15

var aim_turn = 0

var acceleration = 4

var angular_acceleration = 3

onready var tree = $AnimationTree
onready var mesh = $Mesh
onready var camroot = $Camroot/h

var is_aiming = false

func _input(event):
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015

func _physics_process(delta):
	if (Input.is_action_pressed("aim")):
		tree.set("parameters/aim_transmition/current", 0)
		is_aiming = true
	else:
		tree.set("parameters/aim_transmition/current", 1)
		is_aiming = false
		
	var cam_rotation = camroot.global_transform.basis.get_euler().y
	
	if (Input.is_action_pressed("left") ||  Input.is_action_pressed("right") || Input.is_action_pressed("foreward") || Input.is_action_pressed("backward")):
		if(Input.is_action_pressed("sprint") && !is_aiming):
			speed = walk_speed * 2
		else:
			speed = walk_speed
			
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),0,Input.get_action_strength("foreward") - Input.get_action_strength("backward"))
		
		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, cam_rotation).normalized()
	else:
		speed = 0
		strafe_dir = Vector3.ZERO
		
		if (is_aiming):
			direction = camroot.global_transform.basis.z
	
	velocity = lerp(velocity, direction * speed, delta * acceleration)
		
	move_and_slide(velocity, Vector3.UP)
	
	if(!is_aiming):
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	else:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, cam_rotation, delta * angular_acceleration)
		
	strafe = lerp(strafe, strafe_dir + Vector3.RIGHT * aim_turn, delta * acceleration)

	tree.set("parameters/strafe/blend_position", Vector2(-strafe.x, strafe.z))
	
	var iw_blend = (velocity.length() - walk_speed) / walk_speed
	var wr_blend = (velocity.length() - walk_speed) / (walk_speed * 2 - walk_speed)
		
	if velocity.length() <= walk_speed:
		tree.set("parameters/Blend3/blend_amount", iw_blend)
	else:
		tree.set("parameters/Blend3/blend_amount", wr_blend)
		
	aim_turn = 0
	
