extends Control

@export var level_number : int = 0
@export var title : String = "NO TITLE"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$VBoxContainer/Level.text = "LEVEL " + str(level_number)
	$VBoxContainer/Title.text = title
	
	# FADE IN
	$AnimationPlayer.speed_scale = 1.5
	$AnimationPlayer.play("FadeIn")
	await $AnimationPlayer.animation_finished
	
	# PAUSE
	await get_tree().create_timer(1.5).timeout

	# FADE OUT
	$AnimationPlayer.play("FadeOut")
	await $AnimationPlayer.animation_finished
	
	queue_free()
