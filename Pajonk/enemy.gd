extends KinematicBody

enum{
	IDLE,
	ALERT,
	STUNED
}

var target
const TURN_SPEED = 2
var state = IDLE

onready var raycast = $RayCast
onready var ap = $dummymale/AnimationPlayer
onready var eyes = $Eyes
onready var nav = get_parent()

var path = []
var path_node = 0
var speed = 10
func _physics_process(delta):
	match state:
		IDLE:
			ap.play("Idle")
		ALERT:
			ap.play("Alert")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			
			move_to(target.global_transform.origin)
		STUNED:
			ap.play("Stunned")
			
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Area_body_entered(body):
	if(body.is_in_group("player")):
		state = ALERT
		target = body


func _on_Area2_body_exited(body):
	if(body.is_in_group("player")):
		state = IDLE
