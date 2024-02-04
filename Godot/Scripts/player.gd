extends CharacterBody2D

@onready var PlayerAnim = get_node("Sprite2D")

const poop_asset = preload("res://Scenes/cacca.tscn")

var step_speed = 0.200
var step_delay = 0.020

var direction = "r"
var is_moving = false
var source_position = Vector2.ZERO
var target_position = Vector2.ZERO
var poop_counter = 3
var wall_layer = 1
var walls

@onready var map: TileMap = $"../TileMap";

func _init(): pass
	
func _ready():
	walls = map.get_used_cells(wall_layer)
	var start_pos = map.map_to_local(Vector2i(1,1))
	
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", start_pos, 0)

# Called every frame
func _process(delta):
	PlayerMovement(delta)
	PlayerAnimation(is_moving)
	
	if (Input.is_action_just_pressed("ui_left")):
		PlayerState.lastPosition = self.position
		get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	
	if (Input.is_action_just_pressed("ui_right")):
		PlayerState.health += 5
		#aggiorno la UI, va a prendere il nodo "world" dove la funzione è presente
		get_parent().setUp()

func PlayerMovement(delta):
	if is_moving: return
	
	var step = Vector2i.ZERO #Input.get_vector("left", "right", "up", "down")
	if (Input.is_action_pressed("right")):
		step.x = 1
	elif (Input.is_action_pressed("left")):
		step.x = -1
	else:
		if (Input.is_action_pressed("down")):
			step.y = 1
		elif (Input.is_action_pressed("up")):
			step.y = -1
	
	if step == Vector2i.ZERO: return
	
	var cur_pos = position
	var cur_coords = map.local_to_map(cur_pos)
	var next_coords = cur_coords + step
	var is_wall = walls.has(next_coords)
	
	print("from: ", cur_coords, ' to:', next_coords, ' can walk:', !is_wall)
	
	if not is_moving and not is_wall:
		is_moving = true
		source_position = map.map_to_local(cur_coords)
		target_position = map.map_to_local(next_coords)
		var poop = add_poop()
		var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops(1).set_parallel(false)
		tween.tween_property(self, "position", source_position, 0)
		tween.tween_property(self, "position", target_position, step_speed)
		tween.tween_property(self, "position", target_position, step_delay)
		tween.tween_callback( func ():
			is_moving = false
			connect_poop(poop)
		)
		
	
func add_poop():
	if poop_counter > 0: 
		poop_counter -= 1
		var new_poop = poop_asset.instantiate()
		new_poop.position = source_position
		get_tree().root.add_child(new_poop)
		return new_poop

func connect_poop(poop):
	if poop == null: return
	poop.connect("body_entered", collide_poop)

	

func PlayerAnimation(moving = false):
	var val = target_position - source_position
	if (val.x > 0):
		direction = "r"
	elif (val.x < 0):
		direction = "l"
	elif (val.y > 0):
		direction = "d"
	elif (val.y < 0):
		direction = "u"
		
	if (moving):
		PlayerAnim.play("walk_" + direction)
	else:
		PlayerAnim.play("idle_" + direction)
	
func collide_poop(body):
	poop_counter +=3
	print("got pooped paws!")
	
	
func collide_food(body):
	poop_counter +=1 
	
	
