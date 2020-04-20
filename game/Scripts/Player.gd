extends KinematicBody

export var gravity = -9.8
export var rotationSpeed = 3
export var walkSpeed = 6.0
export var acceleration = 3
export var decceleration = 5
export var sprintMultiplier = 3.5
export var sprintEnergyConsumption = 0.3
export var jumpEnergyConsumption = 0.25
export var jumpAcceleration = 250
export var energyRegen = 0.1

var anim
var sprintEnergy = 1.0
var velocity = Vector3()
var energy = 1
var time_start = 0
var started = false

func _ready():
	$Camera.make_current()
	anim = $AnimationPlayer


func movement(delta):
	var dir = Vector3()
	var multiplier = 1
	var consumingEnergy = false

	if(Input.is_action_pressed("move_forward")):
		dir += transform.basis[2]
		if not started:
			started = true
			time_start = OS.get_unix_time()

	if(Input.is_action_pressed("move_left")):
		rotate_y(rotationSpeed*delta)
		if not started:
			started = true
			time_start = OS.get_unix_time()

	if(Input.is_action_pressed("move_right")):
		rotate_y(-rotationSpeed*delta)
		if not started:
			started = true
			time_start = OS.get_unix_time()

	if(Input.is_action_pressed("sprint") && energy > 0):
		multiplier *= sprintMultiplier
		energy = energy - delta*sprintEnergyConsumption
		if not started:
			started = true
			time_start = OS.get_unix_time()
	
	if(Input.is_action_pressed("sprint")):
		consumingEnergy = true
		if not started:
			started = true
			time_start = OS.get_unix_time()

	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta * gravity
	if is_on_floor() && Input.is_action_just_pressed("jump") && energy >= jumpEnergyConsumption:
		velocity.y = jumpAcceleration * delta
		energy -= jumpEnergyConsumption
		anim.play("jump")	
		
		get_parent().get_node("JumpPlayer").play()

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


func _physics_process(delta):
	if GameVariables.gameState == GameVariables.GAMESTATE.running:
		movement(delta)
		
		if started:
			var time_now = OS.get_unix_time()
			var elapsed = time_now - time_start
			
			get_parent().get_node("MarginContainer/Label").text = str(int(elapsed))+"s"
		else:
			get_parent().get_node("MarginContainer/Label").text = "Reach the Ocean!"
		
	get_parent().get_node("MarginContainerEnergy/HBoxContainer/Label").text = str(int(energy*100))+"%"
