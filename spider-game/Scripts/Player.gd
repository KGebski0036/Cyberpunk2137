extends KinematicBody

onready var camroot_h = $Camroot/h
onready var mesh = $CollisionShape

var move_vector = Vector3.ZERO
var speed = 10

var direction
var original_direction
var velocity = Vector3.ZERO

func get_controls():

	move_vector.x = Input.get_action_strength("backward") - Input.get_action_strength("foreward")
	move_vector.z = Input.get_action_strength("left") - Input.get_action_strength("right")
	
func _input(_event):
	get_controls()

		
func _physics_process(delta):
	
	direction = Vector3(move_vector.x,0,move_vector.z) # Vector3(1,0,0)
	original_direction = direction
	var cam_rotation = camroot_h.rotation.y
	direction = direction.rotated(Vector3.UP, cam_rotation).normalized()
	velocity = lerp(velocity, direction * speed, delta * 3)
	
	var _unused_variable = move_and_slide(velocity)
	
	rotation.y = lerp_angle(rotation.y, cam_rotation, delta * 3)
