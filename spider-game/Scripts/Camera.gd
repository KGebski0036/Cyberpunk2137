extends Spatial

var camroot_h = 0
var camroot_v = 0

var cam_v_max = 60
var cam_v_min = -5

export var sensitivity = 0.1
export var acceleration = 10


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera.add_exception(get_parent())
	
func _input(event):
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * sensitivity
		camroot_v += event.relative.y * sensitivity
		
func _physics_process(delta):
	
	camroot_v = clamp(camroot_v, cam_v_min, cam_v_max)
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camroot_h, delta * acceleration)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camroot_v, delta * acceleration)
