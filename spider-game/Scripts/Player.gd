extends KinematicBody


var move_vector = Vector3.ZERO
var speed = 5

func get_controls():

	move_vector.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	move_vector.z = Input.get_action_strength("foreward") - Input.get_action_strength("backward")
	
func _input(_event):
	get_controls()

		
func _physics_process(_delta):
	var _lol = move_and_slide(move_vector * speed)
