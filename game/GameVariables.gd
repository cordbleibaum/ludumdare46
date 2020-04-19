extends Node

enum GAMESTATE{
	running,
	won,
	lost
}

var gameState

func _ready():
	gameState = GAMESTATE.running
