extends CharacterBody2D
@onready var PlayerAnim = get_node("Sprite2D")

const poop_asset = preload("res://Scenes/cacca.tscn")
const food_asset = preload("res://Scenes/food.tscn")
const fly_asset = preload("res://Scenes/fly.tscn")

var step_speed = GameParams.step_speed
var step_delay = GameParams.step_delay
var poops_per_fly = GameParams.poops_per_fly

var direction = "r"
var is_moving = false
var source_position = Vector2.ZERO
var target_position = Vector2.ZERO
var poop_counter = GameParams.initial_poop_count
var poop_ingame = 0
var fly_ingame = 0
var last_cell


var tween
var rng = RandomNumberGenerator.new()
@onready var map
@onready var UI
@onready var viewport

var cells_wall
var cells_start
var cells_finish

var world_min = Vector2i(0,0) 
var world_max = Vector2i(0,0) 

var world_min_cell = Vector2i(0,0) 
var world_max_cell = Vector2i(0,0) 

func _init(): 
	pass
	
func _ready():
	map = $"../TileMap"
	UI = $"../UI"
	viewport = $Camera2D
	
	cells_wall = map.get_used_cells(GameParams.layer_wall)		
	cells_start = map.get_used_cells(GameParams.layer_start)
	cells_finish = map.get_used_cells(GameParams.layer_finish)
		
	for wall in cells_wall:
		if wall.x < world_min_cell.x: world_min_cell.x = wall.x
		if wall.y < world_min_cell.y: world_min_cell.y = wall.y
		if wall.x > world_max_cell.x: world_max_cell.x = wall.x
		if wall.y > world_max_cell.y: world_max_cell.y = wall.y
	
	world_min_cell -= Vector2i(1,1)
	world_max_cell += Vector2i(1,1)
	
	world_min = map.map_to_local(world_min_cell)
	world_max = map.map_to_local(world_max_cell)
	
	viewport.limit_left = world_min.x
	viewport.limit_top = world_min.y
	viewport.limit_right = world_max.x
	viewport.limit_bottom = world_max.y
	
	is_moving=false
	if tween: tween.kill()
	
	var start_pos = map.map_to_local(cells_start.pick_random())
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", start_pos, 0)
	
	UI.update_lifes(GameManager.num_lifes)
	
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
	var cur_cell = map.local_to_map(position)
	if (last_cell == cur_cell): return false
	last_cell = cur_cell
	var foods = get_tree().get_nodes_in_group("food") 
	# print(cur_cell, cells_finish)
	if len(foods) > 0: 
		return false
	if poop_counter > 0: 
		return false
	if not cells_finish.has(cur_cell): 
		return false	
	
	print("you win")
	next()
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
	var fly_should_cnt = floor(poop_ingame / poops_per_fly)
	if fly_ingame >= fly_should_cnt : return
	var new_fly = fly_asset.instantiate()
	new_fly.fly_num = fly_ingame
	new_fly.player = self
	new_fly.map = map
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
	GameManager.num_lifes -= 1
	UI.update_lifes(GameManager.num_lifes)
	death()
	if GameManager.num_lifes == 0:
		GameManager.LoadMenu()
		
	
func collide_poop(body):
	if body != self: return
	print("got pooped paws!", body)
	death()
	
func collide_food(body, food):
	if body != self: return
	eat(food)
	
func eat(food):
	Sfx.eat()
	poop_counter += food.get_potency()
	food.queue_free()
	
	
func death():
	Sfx.death()
	reset()
	
func next():
	tween.kill()
	var flies = get_tree().get_nodes_in_group("fly") 
	for fly in flies: fly.queue_free()
	GameManager.NextLevel()
	
func reset():
	tween.kill()
	var flies = get_tree().get_nodes_in_group("fly") 
	for fly in flies: fly.queue_free()
	GameManager.ReloadLevel()
