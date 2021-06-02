extends Spatial

export(NodePath) var target_path_relative

onready var IK = $Armature/Skeleton/SkeletonIK
onready var RayCastFront = $RayFront
onready var whereisgoal = $WHERESGOAL

onready var target_path_absolute = "../../../" + target_path_relative
onready var target : Spatial = get_node(target_path_relative) 

export var DISTANCE = 3
export var SMOOTHNESS = 0.2

var hitpoint : Vector3
var goalpoint : Vector3
var targetpoint : Vector3 = Vector3.ZERO

#var leg_index = name.substr(3)

func _ready():
	if(RayCastFront.is_colliding()):
		RayCastFront.force_raycast_update()
		hitpoint = RayCastFront.get_collision_point()
	else:
		hitpoint = Vector3.ZERO
	goalpoint = hitpoint
	
	IK.target_node = target_path_absolute
	IK.start()
#
func _physics_process(_delta):
	if RayCastFront.is_colliding():
		hitpoint = RayCastFront.get_collision_point()
		if goalpoint.distance_to(hitpoint) > DISTANCE:
			goalpoint = hitpoint + Vector3.UP*0.5
	targetpoint = targetpoint.linear_interpolate(goalpoint,SMOOTHNESS)
	target.global_transform.origin = targetpoint
	whereisgoal.global_transform.origin = goalpoint
	#target.global_transform.origin = target.global_transform.origin.linear_interpolate(goalpoint,SMOOTHNESS)
