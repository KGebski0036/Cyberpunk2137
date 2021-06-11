extends Spatial

export(NodePath) var target_path_relative
export(NodePath) var default_pos_path_relative

onready var IK = $Armature/Skeleton/SkeletonIK
onready var raycast = $Ray
onready var whereisgoal = $WHERESGOAL
onready var whereitfuckinghits = $WHEREITFUCKINGHITS
onready var player = $"../.."
onready var target_path_absolute = "../../../" + target_path_relative
onready var target : Spatial = get_node(target_path_relative) 
onready var defaultpos = get_node(default_pos_path_relative)

export var DISTANCE = 3.2
export var SMOOTHNESS = 0.15

var index
var hitpoint
var goalpoint
var targetpoint : Vector3 = Vector3.ZERO

var defpos = false
var blocked = false
var kkk
var i
var left = 1

signal moved(witch)
signal dif_position

func _ready():
	raycast.cast_to = Vector3(0,-15,0) 
	raycast.force_raycast_update()
	hitpoint = raycast.get_collision_point()
	goalpoint = hitpoint + Vector3.UP*0.5
	targetpoint = goalpoint
	
	var _yyet = connect("moved", get_parent(), "_on_Leg_moved")
	var _yyet2 = connect("dif_position", get_parent(), "_on_dif_position")
	
	IK.target_node = target_path_absolute
	IK.start()

func _physics_process(_delta):
	if kkk:
		i += SMOOTHNESS
		if defaultpos.global_transform.origin.distance_to(targetpoint) < 0.5 && i > 1:
			emit_signal("moved", index % 2)
			kkk = false
	
	if(player.move_vector != Vector3.ZERO):
		raycast.cast_to = Vector3(player.move_vector.z * 25 * left,-15,-player.move_vector.x * 24 * left) 

		if raycast.is_colliding() && !blocked:
			hitpoint = raycast.get_collision_point()
			if goalpoint.distance_to(hitpoint) > DISTANCE:
				goalpoint = hitpoint + Vector3.UP*0.5
				kkk = true
				i = 0
		
			
	
		
		if !$TimeToDefPos.is_stopped():
			$TimeToDefPos.stop()
			defpos = false
	else:
		raycast.cast_to = Vector3(0,-15,0)
		if $TimeToDefPos.is_stopped():
			$TimeToDefPos.start()
			
		if defpos:
			emit_signal("dif_position")
			hitpoint = raycast.get_collision_point()
			goalpoint = hitpoint + Vector3.UP*0.5

			
	targetpoint = targetpoint.linear_interpolate(goalpoint,SMOOTHNESS)


	target.global_transform.origin = targetpoint
	whereisgoal.global_transform.origin = goalpoint
	whereitfuckinghits.global_transform.origin = hitpoint

func _on_TimeToDefPos_timeout():
	defpos = true

	

