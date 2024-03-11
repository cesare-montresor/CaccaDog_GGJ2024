extends Node2D


func _on_start_pressed():
	GameManager.StartLevel()
	GameManager.num_lifes = GameParams.num_lifes

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_quit_pressed():
	# Va gestita meglio:
	# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
	get_tree().quit()
