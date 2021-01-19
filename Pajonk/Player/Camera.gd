extends Spatial

var camroot_h = 0
var camroot_v = 0

var cam_v_max = 50
var cam_v_min = -5

var h_sensitivity = 0.1
var v_sensitivity = 0.1

var h_acceleraction = 10
var v_acceleraction = 10

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$h/v/Camera.add_exception(get_parent())
	
func _input(event):
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_sensitivity
		camroot_v += event.relative.y * v_sensitivity
		
func _physics_process(delta):
	
	camroot_v = clamp(camroot_v, cam_v_min, cam_v_max)
	
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camroot_h, delta * h_acceleraction)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camroot_v, delta * v_acceleraction)
