class_name TouchUI
extends Node2D

@onready var finger = $Finger
@onready var label = $Label




func _process(delta):
	visible = ControlsTouch.visible
	position = ControlsTouch.start_position
	finger.position = ControlsTouch.finger_position
	label.position = ControlsTouch.finger_position + Vector2(0,20)
