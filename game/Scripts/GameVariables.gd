extends Node

enum GAMESTATE{
	running,
	won,
	lost
}

var gameState


func win():
	gameState = GAMESTATE.won
	
	
func loose():
	gameState = GAMESTATE.lost


func _ready():
	gameState = GAMESTATE.running
