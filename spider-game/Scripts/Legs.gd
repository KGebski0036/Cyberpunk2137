extends Spatial

onready var children = get_children()
onready var box = $"../AVGpos"
onready var player =  $"../CollisionShape"
		
func _physics_process(_delta):
	var sumx = 0
	var sumy = 0
	var sumz = 0
	for it in children:
		sumx += it.goalpoint.x
		sumy += it.goalpoint.y
		sumz += it.goalpoint.z
	box.global_transform.origin = Vector3(sumx/2,sumy/2,sumz/2)
	
	if(box.global_transform.origin.distance_to(player.global_transform.origin) > 1):
		children[0].move()
		children[1].move()
