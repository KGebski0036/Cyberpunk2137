extends Spatial

onready var legs = get_children()

onready var left_legs = [0,3,4,7]

func _ready():
	for i in legs.size():
		
		legs[i].index = int(legs[i].name.substr(3))
		
		if(i % 2 == 0):
			legs[i].blocked = false
			
		if left_legs.has(legs[i].index):
			legs[i].left = -1 #-1 means left 1 means right

func _on_block_even_or_odd_legs(witch):
	for i in legs.size():
		if legs[i].index % 2 == witch:
			legs[i].blocked = true
		else:
			legs[i].blocked = false

func _on_go_to_default_position():
	for i in legs.size():
		if(i % 2 == 0):
			legs[i].blocked = false
		else:
			legs[i].blocked = true

