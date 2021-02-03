extends KinematicBody

var direction = Vector3.BACK
var velocity = Vector3.ZERO

var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO

var speed = 0
var walk_speed = 15

var gravity = 50
var jump = 30
var vertical_velocity = 0
var weight_on_ground = 10

var aim_turn = 0

var acceleration = 4

var angular_acceleration = 3

onready var tree = $AnimationTree
onready var mesh = $Mesh
onready var camroot_h = $Camroot/h

var is_aiming = false
var is_sprinting = false 
var is_jumping = false

var move_vector = Vector2.ZERO

func get_controls():
	is_aiming = Input.is_action_pressed("aim")
	is_sprinting = Input.is_action_pressed("sprint")
	is_jumping = Input.is_action_just_pressed("jump")
	move_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_vector.y = Input.get_action_strength("foreward") - Input.get_action_strength("backward")
	move_vector.x = -move_vector.x
func _input(event):
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	else: get_controls()

func _physics_process(delta):
	if (is_aiming):
		tree.set("parameters/aim_transmition/current", 0)
	else:
		tree.set("parameters/aim_transmition/current", 1)
		
	var cam_rotation = camroot_h.rotation.y 
	
	if (move_vector.length() > 0):
		if(is_sprinting && !is_aiming):
			speed = walk_speed * 2
		else:
			speed = walk_speed
			
		direction = Vector3(move_vector.x,0,move_vector.y) # Vector3(1,0,0)
		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, cam_rotation).normalized()
	else:
		speed = 0
		strafe_dir = Vector3.ZERO
		
		if (is_aiming):
			direction = camroot_h.global_transform.basis.z
	
	velocity = lerp(velocity, direction * speed, delta * acceleration)
		
	move_and_slide(velocity + Vector3.UP * vertical_velocity - get_floor_normal() * weight_on_ground, Vector3.UP,false,4,2)
	var normal = $RayCast.get_collision_normal()
	var xform = align_with_y(global_transform, normal)

	
	

	
	if(!is_on_floor()):
		vertical_velocity -= gravity * delta 
	else:
		if(is_jumping):
			vertical_velocity = jump
		else:
			vertical_velocity = 0
		
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
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
