extends CharacterBody2D

@onready var PlayerAnim = get_node("Sprite2D")

var speed = 250
var step_speed = 250
var step_size = 16

var direction = "r"
var is_moving = false
var target_position = null

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
	
	velocity = Input.get_vector("left", "right", "up", "down")
	
	var step = Vector2.ZERO
	if (velocity.x > 0):
		step.x = 1
	elif (velocity.x < 0):
		step.x = -1
	else:
		if (velocity.y > 0):
			step.y = 1
		elif (velocity.y < 0):
			step.y = -1
		
	
	if not is_moving:
		target_position = position + (step * step_size)
		is_moving = true
	else:
		velocity = (target_position - position) * (delta / step_speed)
		move_and_slide()


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
