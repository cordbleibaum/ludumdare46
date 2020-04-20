extends Area

func _on_WinningArea_body_entered(_body):
	GameVariables.win()
	print("Won!")
	get_parent().get_node("MarginCenter/LabelStatus").text = "You won!"
