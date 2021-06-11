extends Spatial

onready var legs = get_children()

func _ready():
	for i in legs.size():
		legs[i].index = int(legs[i].name.substr(3))
		if(i % 2 == 0):
			legs[i].blocked = false
			
		if legs[i].index == 1 || legs[i].index == 4:
			legs[i].left = -1

func _on_Leg_moved(witch):
	if witch == 0:
		for i in legs.size():
			if legs[i].index % 2 == 0:
				legs[i].blocked = true
			else:
				legs[i].blocked = false
	if witch == 1:
		for i in legs.size():
			if legs[i].index % 2 == 1:
				legs[i].blocked = true
			else:
				legs[i].blocked = false
#	for i in legs.size():
#		print("Leg: " + str(i) + " is " + str(legs[i].blocked))
#

func _on_dif_position():
	for i in legs.size():
		if(i % 2 == 0):
			legs[i].blocked = false
		else:
			legs[i].blocked = true

	
