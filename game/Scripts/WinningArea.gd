extends Area

func _on_WinningArea_body_entered(_sbody):
	GameVariables.gameState = GameVariables.GAMESTATE.won
	print("Won!")
