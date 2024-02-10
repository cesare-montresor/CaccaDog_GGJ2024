extends CharacterBody2D
@onready var PlayerAnim = get_node("Sprite2D")


var fly_script
const reset_scene = "res://Scenes/L01_tutorial.tscn"
const poop_asset = preload("res://Scenes/cacca.tscn")
const food_asset = preload("res://Scenes/food.tscn")


var step_speed = GameParams.step_speed
var step_delay = GameParams.step_delay
var poops_per_fly = GameParams.poops_per_fly

var direction = "r"
var is_moving = false
var source_position = Vector2.ZERO
var target_position = Vector2.ZERO
var poop_counter = 0
var poop_ingame = 0
var fly_ingame = 0

var layer_wall = 1
var layer_start = 2
var layer_finish = 3

var cells_wall
var cells_start
var cells_finish
var play_area = Rect2i(0,0,0,0)
var tween
var rng = RandomNumberGenerator.new()

@onready var map: TileMap = $"../TileMap";

func _init(): 
	fly_script = preload("res://Scripts/fly.gd").new()
	pass
	
func _ready():
	cells_wall = map.get_used_cells(layer_wall)
	for wall in cells_wall:
		if wall.x < play_area.position.x: play_area.position.x = wall.x
		if wall.y < play_area.position.x: play_area.position.y = wall.y
		if wall.x > play_area.position.x + play_area.size.x: play_area.size.x = wall.x - play_area.position.x
		if wall.y > play_area.position.y + play_area.size.y: play_area.size.y = wall.y - play_area.position.y
		
	cells_start = map.get_used_cells(layer_start)
	cells_finish = map.get_used_cells(layer_finish)
	
	
	is_moving=false
	if tween: tween.kill()
	var start_pos = map.map_to_local(cells_start.pick_random())
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", start_pos, 0)
	var foods = get_tree().get_nodes_in_group("food") 
	
	for food in foods:
		food.connect("body_entered", func(body): collide_food(body,food))

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
		
	check_win()
		
func check_win():
	var cur_cell = map.map_to_local(position)
	var foods = get_tree().get_nodes_in_group("food") 
	
	if len(foods) > 0: return false
	if poop_counter > 0: return false
	if cells_finish.has(cur_cell): return false
	
	print("you win")
	return true
		
	

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
	var is_wall = cells_wall.has(next_coords)
	
	#print("from: ", cur_coords, ' to:', next_coords, ' can walk:', !is_wall)
	
	if not is_moving and not is_wall:
		is_moving = true
		source_position = map.map_to_local(cur_coords)
		target_position = map.map_to_local(next_coords)
		var poop = add_poop(source_position)
		add_fly(poop)
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops(1).set_parallel(false)
		tween.tween_property(self, "position", source_position, 0)
		tween.tween_property(self, "position", target_position, step_speed)
		tween.tween_property(self, "position", target_position, step_delay)
		tween.tween_callback( func ():
			if poop: connect_poop(poop)
			is_moving = false
		)
	
	
func add_fly(poop):
	if poop == null: return
	if poop_ingame / poops_per_fly < fly_ingame: return
	var new_fly = fly_script.add_fly()
	get_tree().root.add_child(new_fly)
	fly_ingame += 1
	new_fly.goto_target_poop(poop)
	new_fly.connect("body_entered", func(body): collide_fly(body,new_fly))
	
func add_poop(poop_position):
	if poop_counter <= 0: return 
	poop_counter -= 1
	poop_ingame += 1
	var new_poop = poop_asset.instantiate()
	new_poop.position = poop_position
	get_tree().root.add_child(new_poop)
	Sfx.fart()
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
	
func collide_fly(body, fly):
	if body != self: return
	print("omg a pooped fly!", body)
	
func collide_poop(body):
	if body != self: return
	print("got pooped paws!", body)
	tween.kill()
	var flies = get_tree().get_nodes_in_group("fly") 
	for fly in flies: fly.queue_free()
	Sfx.death()
	get_tree().change_scene_to_file(reset_scene)
	
	
func collide_food(body, food):
	if body != self: return
	Sfx.eat()
	food.queue_free()
	poop_counter += food.get_potency()
	
	
	
