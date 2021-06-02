extends Spatial

export(NodePath) var target_path_relative

onready var IK = $Armature/Skeleton/SkeletonIK
onready var raycast = $Ray
onready var whereisgoal = $WHERESGOAL
onready var whereitfuckinghits = $WHEREITFUCKINGHITS
onready var player = get_parent()
onready var target_path_absolute = "../../../" + target_path_relative
onready var target : Spatial = get_node(target_path_relative) 

export var DISTANCE = 3.2
export var SMOOTHNESS = 0.15

var hitpoint
var goalpoint
var targetpoint : Vector3 = Vector3.ZERO

func _ready():
	raycast.cast_to = Vector3(player.move_vector.z * 15,-15,-player.move_vector.x * 25) 
	raycast.force_raycast_update()
	hitpoint = raycast.get_collision_point()
	goalpoint = hitpoint + Vector3.UP*0.5
	
	IK.target_node = target_path_absolute
	IK.start()

func _physics_process(_delta):
	if(player.move_vector != Vector3.ZERO):
		raycast.cast_to = Vector3(player.move_vector.z * 15,-15,-player.move_vector.x * 25) 
	if raycast.is_colliding():
		hitpoint = raycast.get_collision_point()
		if goalpoint.distance_to(hitpoint) > DISTANCE:
			goalpoint = hitpoint + Vector3.UP*0.5
	targetpoint = targetpoint.linear_interpolate(goalpoint,SMOOTHNESS)
	target.global_transform.origin = targetpoint
	whereisgoal.global_transform.origin = goalpoint
	whereitfuckinghits.global_transform.origin = hitpoint

