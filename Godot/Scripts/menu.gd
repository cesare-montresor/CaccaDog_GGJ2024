extends Node2D

@onready var sound_switch = $Control/SoundSwitch

func _on_start_pressed():
	GameManager.StartLevel()
	GameManager.num_lifes = GameParams.num_lifes

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_quit_pressed():
	# Va gestita meglio:
	# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
	get_tree().quit()

func _on_sound_switch_pressed():
	GameParams.sound = not GameParams.sound
	if GameParams.sound:
		$SoundtrackPlayer.play()
		sound_switch.icon = preload("res://Assets/UI/Speaker.png")
	else:
		$SoundtrackPlayer.stop()
		sound_switch.icon = preload("res://Assets/UI/SpeakerNO.png")
