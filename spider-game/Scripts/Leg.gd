extends Spatial


export(NodePath) var target_path_relative

onready var IK = $Armature/Skeleton/SkeletonIK
onready var RayCastFront = $RayFront
onready var RayCastBack = $RayBack

onready var target_path_absolute = "../../../" + target_path_relative
onready var target = target_path_relative

var kkk 

func _ready():
	IK.target_node = target_path_absolute
	IK.start()
	
func _physics_process(_delta):
	if RayCastFront.is_colliding():
		kkk = RayCastFront.get_collision_point()
		set_global_position(target, kkk)


func set_global_position(spatial_node, vector3_position):
	spatial_node.set_global_transform(Transform(spatial_node.get_global_transform().basis,vector3_position))

