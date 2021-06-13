extends KinematicBody


var move_vector = Vector3.ZERO
var speed = 10

func get_controls():

	move_vector.x = Input.get_action_strength("backward") - Input.get_action_strength("foreward")
	move_vector.z = Input.get_action_strength("left") - Input.get_action_strength("right")
	
func _input(_event):
	get_controls()

		
func _physics_process(_delta):
	var _unused_variable = move_and_slide(move_vector * speed)
