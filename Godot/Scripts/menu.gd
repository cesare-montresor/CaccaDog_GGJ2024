extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/L01_tutorial.tscn")

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/L01_tutorial.tscn")

func _on_level_2_pressed():
	pass # Replace with function body.


func _on_level_3_pressed():
	pass # Replace with function body.


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_quit_pressed():
	# Va gestita meglio:
	# https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
	get_tree().quit()
