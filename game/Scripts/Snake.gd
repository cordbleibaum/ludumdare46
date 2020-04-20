extends KinematicBody

export var speed = 3
export var gravity = -9.81
export var triggerDistance = 15
export var gameoverDistance = 0.8

var nav
var player

var velocity = Vector3()

func _ready():
	nav = get_tree().get_root().get_node("Spatial/Navigation")
	player = get_tree().get_root().get_node("Spatial/Player")


func _physics_process(delta):
	if GameVariables.gameState == GameVariables.GAMESTATE.running:
		var path = nav.get_simple_path(self.get_translation()+Vector3(0,0.5,0), player.get_translation())
		
		if path.size() > 0 && self.get_translation().distance_to(player.get_translation()) < triggerDistance:
			var nextPos = path[1]
		
			var movementTarget = (nextPos - transform.origin)
			movementTarget.y = 0;
			movementTarget = movementTarget.normalized() * speed
			
			translation += movementTarget * delta
			
			look_at(player.get_translation(), Vector3(0,1,0))
			
			if self.get_translation().distance_to(player.get_translation()) < gameoverDistance:
				GameVariables.loose()
				get_parent().get_node("MarginCenter/LabelStatus").text = "You Lost!"
