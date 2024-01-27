extends CharacterBody2D

@onready var PlayerAnim = get_node("Sprite2D")

var step_speed = 0.100
var step_size_px = 16
var step_size = 0 

var direction = "r"
var is_moving = false
var source_position = null
var target_position = null

func _init():
	step_size = step_size_px * 3

# Called every frame
func _process(delta):
	PlayerMovement(delta)
	PlayerAnimation()
	
	if (Input.is_action_just_pressed("ui_left")):
		PlayerState.lastPosition = self.position
		get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
	if (Input.is_action_just_pressed("ui_right")):
		PlayerState.health += 5
		#aggiorno la UI, va a prendere il nodo "world" dove la funzione è presente
		get_parent().setUp()
		

func PlayerMovement(delta):
	
	var step = Input.get_vector("left", "right", "up", "down")
	if (velocity.x > 0):
		step.x = 1
	elif (velocity.x < 0):
		step.x = -1
	else:
		if (velocity.y > 0):
			step.y = 1
		elif (velocity.y < 0):
			step.y = -1
	
	
	
	if not is_moving and step != Vector2.ZERO:
		source_position = position
		target_position = position + (step * step_size)
		var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops(1).set_parallel(false)
		tween.tween_property(self, "position", source_position, step_speed)
		tween.tween_property(self, "position", target_position, step_speed)
		tween.tween_callback( endMovment )

func endMovment():
	is_moving = false


func PlayerAnimation():
	if (velocity.x > 0):
		direction = "r"
	elif (velocity.x < 0):
		direction = "l"
	elif (velocity.y > 0):
		direction = "d"
	elif (velocity.y < 0):
		direction = "u"
		
	if (velocity == Vector2.ZERO):
		PlayerAnim.play("idle_" + direction)
	else:
		PlayerAnim.play("walk_" + direction)
