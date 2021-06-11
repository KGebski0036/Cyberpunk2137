extends KinematicBody


var move_vector = Vector3.ZERO
var speed = 10

var bugg = false

func get_controls():

	move_vector.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	move_vector.z = Input.get_action_strength("foreward") - Input.get_action_strength("backward")
	if Input.is_action_pressed("u_get_stick_bugg"):
		$"../Timer".start()
		move_vector.z = 0.5
		bugg = true
		for i in $LegsControler.legs.size():
			$LegsControler.legs[i].blocked = true
	
func _input(_event):
	if !bugg:
		get_controls()

		
func _physics_process(_delta):
	var _lol = move_and_slide(move_vector * speed)



func _on_Timer_timeout():

	move_vector.z = -move_vector.z
