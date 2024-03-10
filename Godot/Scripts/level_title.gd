extends CanvasLayer

@export var show_level_number : bool
@export var title : String = "NO TITLE"

# Called when the node enters the scene tree for the first time.
func _ready():
	await to_transp()

	$Control/CenterContainer/VBoxContainer/Level.visible = show_level_number
	$Control/CenterContainer/VBoxContainer/Level.text = "LEVEL " + str(GameManager.current_level + 1)
	
		
	$Control/CenterContainer/VBoxContainer/Title.text = title
	await title_in_out()
	#queue_free()
	
func to_transp():
	# TO TRANSPARENT
	$Control/ColorRect.visible = true
	$AnimationPlayer.speed_scale = 1.2
	$AnimationPlayer.play("ToTransp")
	await $AnimationPlayer.animation_finished
	$Control/ColorRect.visible = false

func to_blk():
	# TO TRANSPARENT
	$Control/ColorRect.visible = true
	$AnimationPlayer.speed_scale = 1.2
	$AnimationPlayer.play("ToBlk")
	await $AnimationPlayer.animation_finished
	$Control/ColorRect.visible = false
	
func to_white():
	# TO TRANSPARENT
	$Control/ColorRect.visible = true
	$AnimationPlayer.speed_scale = 1.2
	$AnimationPlayer.play("ToWhite")
	await $AnimationPlayer.animation_finished
	$Control/ColorRect.visible = false

func title_in_out():
	# TITLE FADE IN
	$AnimationPlayer.speed_scale = 1.5
	$AnimationPlayer.play("TitleFadeIn")
	await $AnimationPlayer.animation_finished
	
	# PAUSE
	await get_tree().create_timer(1.5).timeout

	# TITLE FADE OUT
	$AnimationPlayer.play("TitleFadeOut")
	await $AnimationPlayer.animation_finished
	
		
	
