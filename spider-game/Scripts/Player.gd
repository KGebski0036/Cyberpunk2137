extends KinematicBody


var move_vector = Vector3.ZERO
var speed = 20



func get_controls():

	move_vector.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	move_vector.z = Input.get_action_strength("foreward") - Input.get_action_strength("backward")
	
func _input(event):
	get_controls()
	if Input.get_action_strength("right_click"):
		$"../Camera1".current = false
		$"../Camera2".current = true
		print(GlobalVariables.lo)
		GlobalVariables.lo += 1
	if Input.get_action_strength("ui_end"):
		get_tree().reload_current_scene()

		
func _physics_process(delta):
	move_and_slide(move_vector * speed)
