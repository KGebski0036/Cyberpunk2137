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
onready var raycast = $RayCast

var is_aiming = false
var is_sprinting = false 
var is_jumping = false

var max_hp = 20
var hp = max_hp

var deds = 0
var is_demaged = false
var demage_deal = 0
onready var demage_timer = $DemageTimer

var move_vector = Vector2.ZERO

onready var hp_label = $Interface/Bar/Counter/Label as Label
onready var hp_bar = $Interface/Bar/HP_bar as TextureProgress
onready var deds_label = $Interface/Deds/Label

func update_interface():
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = "Hp " + hp as String + "/" + max_hp as String
	deds_label.text = deds as String



func get_controls():
	
	is_aiming = Input.is_action_pressed("aim")
	is_sprinting = Input.is_action_pressed("sprint")
	is_jumping = Input.is_action_just_pressed("jump")
	
	move_vector.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	move_vector.y = Input.get_action_strength("foreward") - Input.get_action_strength("backward")

func _input(event):
	
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	else: 
		get_controls()

func check_animation():
	if (is_aiming):
		tree.set("parameters/aim_Fmition/current", 0)
	else:
		tree.set("parameters/aim_transmition/current", 1)

func check_direction():
	if (move_vector.length() > 0):
		var cam_rotation = camroot_h.rotation.y
		
		if(is_sprinting && !is_aiming):
			speed = walk_speed * 2
		else:
			speed = walk_speed
			
		direction = Vector3(move_vector.x,0,move_vector.y)
		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, cam_rotation).normalized()
	else:
		speed = 0
		strafe_dir = Vector3.ZERO
		
		if (is_aiming):
			direction = camroot_h.global_transform.basis.z

func check_jump(delta):
	if(!is_on_floor()):
		vertical_velocity -= gravity * delta 

	else:
		if(is_jumping):
			vertical_velocity = jump
		else:
			vertical_velocity = 0

func check_mesh_rotate(delta):
	if(!is_aiming):
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	else:
		var cam_rotation = camroot_h.rotation.y
		mesh.rotation.y = lerp_angle(mesh.rotation.y, cam_rotation, delta * angular_acceleration)

func check_demage():
	if demage_timer.is_stopped():
		demage_timer.start()
		hp -= demage_deal
	
func _physics_process(delta):
	
	check_animation()
	
	check_direction()
	if(is_demaged):
		check_demage()
	
	velocity = lerp(velocity, direction * speed, delta * acceleration)
	
	update_interface()
	
	move_and_slide(velocity + Vector3.UP * vertical_velocity - get_floor_normal() * weight_on_ground, Vector3.UP,false,4,2)
	
	check_jump(delta)
	
	check_mesh_rotate(delta)
		
	strafe = lerp(strafe, strafe_dir + Vector3.RIGHT * aim_turn, delta * acceleration)
	
	tree.set("parameters/strafe/blend_position", Vector2(-strafe.x, strafe.z))
	
	var iw_blend = (velocity.length() - walk_speed) / walk_speed
	var wr_blend = (velocity.length() - walk_speed) / (walk_speed * 2 - walk_speed)
		
	if velocity.length() <= walk_speed:
		tree.set("parameters/Blend3/blend_amount", iw_blend)
	else:
		tree.set("parameters/Blend3/blend_amount", wr_blend)
	
	aim_turn = 0
	
