extends Area

func _on_WinningArea_body_entered(body):
	GameVariables.gameState = GameVariables.GAMESTATE.won
	print("Won!")
