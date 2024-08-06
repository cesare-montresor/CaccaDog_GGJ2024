extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# PAUSE
	if GameParams.sound:
		$AudioStreamPlayer.play()
	await get_tree().create_timer(7.5).timeout
	
	await $LevelTitle.to_white()
	GameManager.LoadMenu()
