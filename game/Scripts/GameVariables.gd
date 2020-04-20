extends Node

enum GAMESTATE{
	running,
	won,
	lost
}

var gameState
var timer

func win():
	gameState = GAMESTATE.won
	
	
func loose():
	gameState = GAMESTATE.lost
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "timer_restart")
	timer.set_wait_time(4.0)
	timer.set_one_shot(true)
	timer.start()


func timer_restart():
	gameState = GAMESTATE.running
	get_tree().change_scene("res://TestScene.tscn")


func _ready():
	gameState = GAMESTATE.running
