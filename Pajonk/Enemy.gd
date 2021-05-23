extends KinematicBody

onready var player = $"../../../Player" as KinematicBody

var speed = 15
var aggresive = false

func _physics_process(delta):
	if aggresive:
		move_and_slide((player.global_transform.origin - global_transform.origin).normalized() * speed)
	


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		aggresive = true
		print("wrr")


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		aggresive = false
		print("meh")


func _on_DemageArea_body_entered(body):
	if body.is_in_group("player"):
		body.is_demaged = true
		body.demage_deal += 2


func _on_DemageArea_body_exited(body):
	if body.is_in_group("player"):
		body.is_demaged = false
		body.demage_deal -= 2
