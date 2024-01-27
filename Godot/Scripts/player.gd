extends CharacterBody2D

@onready var PlayerAnim = get_node("Sprite2D")

const poop_asset = preload("res://Scenes/cacca.tscn")

var step_speed = 0.200
var step_delay = 0.050
var step_size_px = 16
var step_mul_px = 4
var step_size = 0 

var direction = "r"
var is_moving = false
var source_position = Vector2.ZERO
var target_position = Vector2.ZERO
var last_direction = Vector2.ZERO
var tween: Tween = null
var poop_counter = 3

func _init():
	step_size = step_size_px * step_mul_px
	position = Vector2.ZERO

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
	
	var step = Vector2.ZERO #Input.get_vector("left", "right", "up", "down")
	if (Input.is_action_pressed("right")):
		step.x = 1
	elif (Input.is_action_pressed("left")):
		step.x = -1
	else:
		if (Input.is_action_pressed("down")):
			step.y = 1
		elif (Input.is_action_pressed("up")):
			step.y = -1
	
	if step != Vector2.ZERO and step - last_direction != Vector2.ZERO:
		last_direction = step
	
	if not is_moving and last_direction != Vector2.ZERO:
		is_moving = true
		print("start")
		source_position = position
		target_position = position + (last_direction * step_size)
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops(1).set_parallel(false)
		tween.tween_property(self, "position", source_position, 0)
		tween.tween_property(self, "position", target_position, step_speed)
		tween.tween_property(self, "position", target_position, step_delay)
		tween.tween_callback( endMovment )
		
	

	
func endMovment():
	tween.kill()
	print("end")
	if poop_counter > 0: 
		poop_counter -= 1
		var new_poop = poop_asset.instantiate()
		new_poop.position = source_position
		get_tree().root.add_child(new_poop)
		
	is_moving = false
	
	
func endMovmentBlock():
	is_moving = false

func PlayerAnimation():
	var val = target_position - source_position
	if (val.x > 0):
		direction = "r"
	elif (val.x < 0):
		direction = "l"
	elif (val.y > 0):
		direction = "d"
	elif (val.y < 0):
		direction = "u"
		
	if (velocity == Vector2.ZERO):
		PlayerAnim.play("idle_" + direction)
	else:
		PlayerAnim.play("walk_" + direction)


func _on_area_2d_body_entered(body):
	collide_walls(body)
	#collide_food(body)
	
func collide_food(body):
	poop_counter +=1 
	
	
func collide_walls(body):
	if (tween != null):
		tween.kill()
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", source_position, 0)
	tween.tween_callback( endMovmentBlock )
	print("sono toccato!")
