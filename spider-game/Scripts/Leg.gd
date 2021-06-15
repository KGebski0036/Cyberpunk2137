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
onready var timer_to_default_pos = $TimeToDefPos

export var DISTANCE = 3.2
export var SMOOTHNESS = 0.15

var index
var hitpoint
var goalpoint
var targetpoint : Vector3 = Vector3.ZERO

var default_pos = false
var blocked = false
var leg_go_to_goalpoint = false
var leg_move_progress # 0-1 means going towards the end of motion, >1 means going back
var left = 1 # -1 means left 1 means right

signal block_even_or_odd_legs(which)
signal go_to_default_position()

func _ready():
	raycast.cast_to = Vector3(0,-15,0) 
	raycast.force_raycast_update()
	hitpoint = raycast.get_collision_point()
	goalpoint = hitpoint + Vector3.UP*0.5
	targetpoint = goalpoint
	
	var _uv0 = connect("block_even_or_odd_legs", get_parent(), "_on_block_even_or_odd_legs")
	var _uv1 = connect("go_to_default_position", get_parent(), "_on_go_to_default_position")
	
	IK.target_node = target_path_absolute
	IK.start()

func _physics_process(_delta):
	if leg_go_to_goalpoint:
		leg_move_progress += SMOOTHNESS
		if defaultpos.global_transform.origin.distance_to(targetpoint) < 0.5 && leg_move_progress > 1:
			emit_signal("block_even_or_odd_legs", index % 2)
			leg_go_to_goalpoint = false
	
	if(player.move_vector != Vector3.ZERO):
		raycast.cast_to = Vector3(player.move_vector.z * 25 * left,-15,-player.move_vector.x * 24 * left) 

		if raycast.is_colliding() && !blocked:
			hitpoint = raycast.get_collision_point()
			if goalpoint.distance_to(hitpoint) > DISTANCE:
				goalpoint = hitpoint + Vector3.UP*0.5
				leg_go_to_goalpoint = true
				leg_move_progress = 0
		
			timer_to_default_pos.stop()
			default_pos = false
		targetpoint = targetpoint.linear_interpolate(goalpoint,SMOOTHNESS)
	else:
		raycast.cast_to = Vector3(0,-15,0)
		if timer_to_default_pos.is_stopped():
			timer_to_default_pos.start()
			
		if default_pos:
			emit_signal("go_to_default_position")
			hitpoint = raycast.get_collision_point()
			goalpoint = hitpoint + Vector3.UP*0.5
			targetpoint = targetpoint.linear_interpolate(goalpoint,SMOOTHNESS)
			
	


	target.global_transform.origin = targetpoint
	whereisgoal.global_transform.origin = goalpoint
	whereitfuckinghits.global_transform.origin = hitpoint

func _on_TimeToDefPos_timeout():
	default_pos = true

	

