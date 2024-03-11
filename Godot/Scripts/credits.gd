extends Node2D


func _input(event):
	print(event.as_text())	
	if event is InputEventMouseButton or event is InputEventKey:
		await $LevelTitle.to_white()
		GameManager.LoadMenu()
