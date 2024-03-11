extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Opening")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.8).timeout	
	GameManager.LoadMenu()
	
