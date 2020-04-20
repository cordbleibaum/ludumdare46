extends Spatial

onready var animTree = $AnimationTree
var target : Spatial
export var speed : float = 1

func _ready():
	pass

func _process(delta):
	var velocity : Vector3 = Vector3(0,0,0)
	if target != null:
		velocity = delta * speed * (target.translation - translation).normalized()
	
	animTree["parameters/conditions/wiggle"] = velocity.length() > 0.01
