extends KinematicBody

export var speed = 3
export var gravity = -9.81

var nav
var player

var velocity = Vector3(0, 0, 0)

func _ready():
	nav = get_tree().get_root().get_node("Spatial/Navigation")
	player = get_tree().get_root().get_node("Spatial/Player")


func _physics_process(delta):
	var path = nav.get_simple_path(self.get_translation(), player.get_translation())
	
	if path.size() > 0:
		var nextPos = path[1]
	
		var movementTarget = (nextPos - transform.origin)
		movementTarget = movementTarget.normalized() * speed
		
		velocity.x = movementTarget.x
		velocity.z = movementTarget.z
	
		move_and_slide(movementTarget, Vector3(0,1,0))
		look_at(player.get_translation(), Vector3(0,1,0))
