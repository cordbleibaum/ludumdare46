extends KinematicBody

export var speed = 3

var nav
var player

func _ready():
	nav = get_tree().get_root().get_node("Spatial/Navigation")
	player = get_tree().get_root().get_node("Spatial/Player")


func _physics_process(delta):
	var path = nav.get_simple_path(self.get_translation(), player.get_translation())
	var nextPos = path[1]

	var movement = (nextPos - transform.origin)
	movement = movement.normalized() * speed 

	move_and_slide(movement, Vector3(0,1,0))
	look_at(player.get_translation(), Vector3(0,1,0))
