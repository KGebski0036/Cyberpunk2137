extends Spatial


export(NodePath) var target_path_relative

onready var IK = $Armature/Skeleton/SkeletonIK
onready var RayCastFront = $RayFront

onready var target_path_absolute = "../../../" + target_path_relative
onready var target = get_node(target_path_relative)

var hitpoint
var move = false
var leg_index = name.substr(3)

func _ready():
	hitpoint = RayCastFront.get_collision_point()
	IK.target_node = target_path_absolute
	IK.start()
	
func _physics_process(_delta):
	if target.global_transform.origin.distance_to(hitpoint) > 0.5 && move:
		target.global_transform.origin = target.global_transform.origin.linear_interpolate(hitpoint,0.1)
		
	if target.global_transform.origin.distance_to(hitpoint) < 0.5 && move:
		move = false

	if RayCastFront.is_colliding():
		hitpoint = RayCastFront.get_collision_point()
		hitpoint.y += 0.5
		
		if target.global_transform.origin.distance_to(hitpoint) > 2:
			move = true
			#target.set_global_transform(lerp(target.global_transform, Transform(target.get_global_transform().basis,hitpoint), 0.5))
			
