extends Node2D

var tick_up = 0
var tick_down = 0
var tick_left = 0
var tick_right = 0

# "GameManager" is a singleton for top level GameManager data.

func _ready():
	#if !	OS.has_touchscreen_ui_hint():
	pass



func _process(_delta):
	if !GameParams.keyboard_controls_enabled:
		return
	handle_keyboard_events()
	
func handle_keyboard_events():
	"""
	# OLD
	var step = Vector2i.ZERO #Input.get_vector("left", "right", "up", "down")
	if (Input.is_action_pressed("right")):
		step.x = 1
	elif (Input.is_action_pressed("left")):
		step.x = -1
	elif (Input.is_action_pressed("down")):
		step.y = 1
	elif (Input.is_action_pressed("up")):
		step.y = -1
	"""
	
	# new
	if (Input.is_action_just_pressed("right")):
		tick_right = Time.get_ticks_usec()
	if (Input.is_action_just_pressed("left")):
		tick_left = Time.get_ticks_usec()
	if (Input.is_action_just_pressed("down")):
		tick_down = Time.get_ticks_usec()
	if (Input.is_action_just_pressed("up")):
		tick_up = Time.get_ticks_usec()
	
	
	if (!Input.is_action_pressed("right")):
		tick_right = 0
	if (!Input.is_action_pressed("left")):
		tick_left = 0
	if (!Input.is_action_pressed("down")):
		tick_down = 0
	if (!Input.is_action_pressed("up")):
		tick_up = 0
		
	
	
	#print('L:', tick_left, ' R:', tick_right, ' U:', tick_up, ' D:', tick_down )
	if GameManager.is_moving: return
	
	var step = Vector2i.ZERO #Input.get_vector("left", "right", "up", "down")
	if ( tick_right > tick_up && tick_right > tick_left && tick_right > tick_down ): # right
		step = Vector2i.RIGHT #1
	elif ( tick_left > tick_up && tick_left > tick_right && tick_left > tick_down ): # left
		step = Vector2i.LEFT
	elif ( tick_down > tick_up && tick_down > tick_right && tick_down > tick_left ): # down
		step = Vector2i.DOWN
	elif ( tick_up > tick_down  && tick_up > tick_right && tick_up > tick_left ): # up
		step = Vector2i.UP
		
	
	#if step != Vector2i.ZERO:
	#	GameManager.step = step
	
	GameManager.step = step
