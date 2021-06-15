extends Spatial

onready var legs = get_children()
onready var body = get_parent()
onready var left_legs = [0,3,4,7]

var distance_between_foreward_and_backward_legs = 4.53
var distance_between_left_and_right_legs = 1.32

func _ready():
	for i in legs.size():
		legs[i].index = int(legs[i].name.substr(3))
		
		if(i % 2 == 0):
			legs[i].blocked = false
		
		if left_legs.has(legs[i].index):
			legs[i].left = -1 #-1 means left 1 means right
	
#	distance_between_left_and_right_legs = legs[0].targetpoint.distance_to(legs[3].targetpoint)
#	distance_between_foreward_and_backward_legs = legs[0].targetpoint.distance_to(legs[1].targetpoint)

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
func _physics_process(_delta):
	
	set_body_rotation( check_rotation() )

func check_rotation():
	var forward_point = 0
	var backward_point = 0
	var left_point = 0
	var right_point = 0
	
	for leg in legs:
		if leg.index > 1:
			forward_point += leg.targetpoint.y
		else:
			backward_point += leg.targetpoint.y
		if leg.left == -1:
			left_point += leg.targetpoint.y
		else:
			right_point += leg.targetpoint.y
	return [forward_point, backward_point, left_point, right_point]
func set_body_rotation(_points):
	pass
