extends Spatial

onready var legs = get_children()
onready var body = get_parent()
onready var left_legs = [0,3,4,7]

func _ready():
	for i in legs.size():
		legs[i].index = int(legs[i].name.substr(3))
		
		if(i % 2 == 0):
			legs[i].blocked = false
		
		if left_legs.has(legs[i].index):
			legs[i].left = -1 #-1 means left 1 means right

func _on_block_even_or_odd_legs(which):
	for i in legs.size():
		if legs[i].index % 2 == which:
			legs[i].blocked = true
		else:
			legs[i].blocked = false

func _on_go_to_default_position():
	for i in legs.size():
		if i % 2 == 0:
			legs[i].blocked = false
		else:
			legs[i].blocked = true
func _physics_process(delta):
	var right_leg_height_sum = 0 
	var left_leg_height_sum = 0 
	for leg in legs:
		if leg.left == -1:
			left_leg_height_sum += leg.targetpoint.y
		else:
			right_leg_height_sum+=leg.targetpoint.y
	var right_average_height = right_leg_height_sum/legs.size()/2
	var left_average_height = left_leg_height_sum/legs.size()/2
	print(right_average_height,left_average_height)
	var leg_distance = 4.5
	
	var bodytransform = body.transform

