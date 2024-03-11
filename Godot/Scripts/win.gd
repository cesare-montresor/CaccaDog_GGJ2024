extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3.5).timeout
	$AnimationPlayer.play("LogoInOut")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1.0).timeout	
	await $LevelTitle.to_white()
	GameManager.LoadCredits()
	
