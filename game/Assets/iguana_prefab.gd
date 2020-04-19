extends KinematicBody

export var gravity = -9.8
export var rotationSpeed = 3
export var walkSpeed = 6
export var acceleration = 3
export var decceleration = 5
export var sprintMultiplier = 2
export var sprintEnergyConsumption = 0.3
export var energyRegen = 0.1

var anim
var sprintEnergy = 1.0
var velocity = Vector3()
var energy = 1

func _ready():
	$Camera.make_current()
	anim = get_parent().get_node("AnimationPlayer")


func _physics_process(delta):
	var dir = Vector3()
	var multiplier = 1
	var consumingEnergy = false

	if(Input.is_action_pressed("move_forward")):
		dir += transform.basis[2]

	if(Input.is_action_pressed("move_left")):
		rotate_y(rotationSpeed*delta)

	if(Input.is_action_pressed("move_right")):
		rotate_y(-rotationSpeed*delta)

	if(Input.is_action_pressed("sprint") && energy > 0):
		multiplier *= sprintMultiplier
		energy = energy - delta*sprintEnergyConsumption
	
	if(Input.is_action_pressed("sprint")):
		consumingEnergy = true

	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta * gravity

	var hv = velocity
	hv.y = 0

	var new_pos = dir * walkSpeed * multiplier
	var accel = decceleration

	if (dir.dot(hv) > 0):
		accel = acceleration
		
	if multiplier > 1 && new_pos.dot(new_pos) > 0.1:
		anim.play("run")
	elif new_pos.dot(new_pos) > 0.1:
		if(not anim.is_playing()):
			anim.play("walk")
	else:
		anim.stop()

	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))	
	
	if not consumingEnergy:
		energy = min(1.0, energy + delta*energyRegen)
	else:
		energy = max(0.0, energy)
