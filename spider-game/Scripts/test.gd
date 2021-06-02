extends Spatial

onready var target = $Target
onready var goal = $Goal
onready var shooter = $RayShooter
onready var raycast = $RayShooter/RayCast

export var DISTANCE = 5 
export var SMOOTHNESS = 0.1

var raycastpoint = Vector3.ZERO
var goalpoint = Vector3.ZERO
var targetpoint = Vector3.ZERO

func _ready():
	raycast.force_raycast_update()
	if(raycast.is_colliding()):
		goalpoint = raycast.get_collision_point()
		targetpoint = goalpoint

func _physics_process(delta):
	if(raycast.is_colliding()):
		raycastpoint = raycast.get_collision_point() + (Vector3.UP * 0.5)
		if(goalpoint.distance_to(raycastpoint) > DISTANCE):
			goalpoint = raycastpoint
	targetpoint = targetpoint.linear_interpolate(goalpoint, SMOOTHNESS)
	shooter.translate(Vector3.RIGHT * 0.1)
	goal.transform.origin  = goalpoint
	target.transform.origin = targetpoint
