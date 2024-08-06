extends Node2D

var finger_position = Vector2.ZERO
var start_position = Vector2.ZERO
var last_position = Vector2.ZERO

var dir = ""
var last_dir = ""
var drag_held = false

var touch_bound = 24
var touch_bounds_min = Vector2(-touch_bound, -touch_bound)
var touch_bounds_max = Vector2(touch_bound , touch_bound)


# "GameManager" is a singleton for top level GameManager data.


func _ready():
	#if !	OS.has_touchscreen_ui_hint():
	#	queue_free()
	
	
	if GameManager.touch_position == Vector2.ZERO:
		visible = false
	else:
		position = GameManager.touch_position
		start_position = GameManager.touch_position 
		finger_position = GameManager.touch_finger_position
		get_dir(finger_position)

func _unhandled_input(event):
	if !GameParams.touch_controls_enabled: return
	handle_touch_events(event)	
	
	
func handle_touch_events(event):
	if event is InputEventScreenTouch || event is InputEventMouseButton:
	
		
		if event.pressed == true:
			if start_position == Vector2.ZERO:
				start_position = event.position
				position = event.position 
				GameManager.touch_position = position
				visible = true
				drag_held = true
			last_position = event.position
		else:
			var _diff = event.position - start_position
			
			start_position = Vector2.ZERO
			GameManager.touch_position = Vector2.ZERO
			visible = false
			dir = ""
			drag_held = false
			finger_position = Vector2.ZERO
			GameManager.touch_finger_position = Vector2.ZERO
			GameManager.step = Vector2i.ZERO

			
	if event is InputEventScreenDrag :
		finger_position = event.position - start_position
		finger_position = finger_position.clamp(touch_bounds_min,touch_bounds_max)
		GameManager.touch_finger_position = finger_position
		var diff = event.position - start_position
		drag_held = true
		dir = ""
		get_dir(diff)
			
	if event is InputEventMouseMotion:	

		if drag_held  == true:
			finger_position = event.position - start_position
			finger_position = finger_position.clamp(touch_bounds_min,touch_bounds_max)
			GameManager.touch_finger_position = finger_position
			var diff = event.position - start_position
			dir = ""
			get_dir(diff)
				

func _process(_delta):
	if !GameParams.touch_controls_enabled:
		return
	match dir:
		"move_left":
			GameManager.step = Vector2i.LEFT
		"move_right":
			GameManager.step = Vector2i.RIGHT
		"move_up":
			GameManager.step = Vector2i.UP
		"move_down":
			GameManager.step = Vector2i.DOWN
		"": pass
		#	GameManager.step = Vector2i.ZERO

			
func get_dir(diff):
	if diff.length_squared() > GameParams.tile_size**2:
		if abs(diff.x) > abs(diff.y):
			#label.text = "abs x : " + str(abs(diff.x))
			if diff.x < 0:
				dir = "move_left"
				#label.text = "move_left" 
			elif diff.x > 0:
				dir = "move_right"
				#label.text = "move_right" 
		else:
			#label.text = "abs y : " + str(abs(diff.y))
			if diff.y < 0:
				dir = "move_up"
				#label.text = "move_up" 
			elif diff.y > 0:
				dir = "move_down"
				#label.text = "move_down" 
