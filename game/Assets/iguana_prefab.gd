extends KinematicBody

var gravity = -9.8
var velocity = Vector3()


export var walkSpeed = 6
export var acceleration = 3
export var decceleration = 5

var anim

func _ready():
	$Camera.make_current()
	anim = get_parent().get_node("AnimationPlayer")


func _physics_process(delta):
	var dir = Vector3()

	if(Input.is_action_pressed("move_forward")):
		dir += transform.basis[2]

	if(Input.is_action_pressed("move_left")):
		rotate_y(2*delta)

	if(Input.is_action_pressed("move_right")):
		rotate_y(-2*delta)

	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta * gravity

	var hv = velocity
	hv.y = 0

	var new_pos = dir * walkSpeed
	var accel = decceleration

	if (dir.dot(hv) > 0):
		accel = acceleration
		
	if hv.dot(hv) > 0.1:
		if(not anim.is_playing()):
			anim.play("walk")

	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))	
