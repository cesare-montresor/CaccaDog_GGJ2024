extends CharacterBody2D
@onready var PlayerAnim = get_node("Sprite2D")

const poop_asset = preload("res://Scenes/cacca.tscn")
const food_asset = preload("res://Scenes/food.tscn")
const fly_asset = preload("res://Scenes/fly.tscn")

var step_speed = GameParams.step_speed
var step_delay = GameParams.step_delay
var poops_per_fly = GameParams.poops_per_fly

var direction = "r"
#var is_moving = false
var source_position = Vector2.ZERO
var target_position = Vector2.ZERO
var poop_counter = GameParams.initial_poop_count
var poop_ingame = 0
var fly_ingame = 0
var last_cell
var alive = true


var tween
var rng = RandomNumberGenerator.new()
@onready var map: TileMap
@onready var UI
@onready var viewport: Camera2D
@onready var level_title

var cells_wall
var cells_start
var cells_finish
var start_coords
var stop_coords 


var total_poops=0
var can_finish=false

var world_min = Vector2i(0,0) 
var world_max = Vector2i(0,0) 

var world_min_cell = Vector2i(0,0) 
var world_max_cell = Vector2i(0,0) 

func _init(): 
	pass
	
func _ready():
	map = $"../TileMap" as TileMap
	UI = $"../UI"
	#viewport = $Camera2D as Camera2D
	level_title = $"../LevelTitle"
	
	
	var layer_wall = GameParams.layer_wall
	var layer_start = GameParams.layer_start
	var layer_finish = GameParams.layer_finish
	var tileset_source_id = GameParams.tileset_source_id
	
	
	GameManager.player = self
	
	cells_wall = map.get_used_cells(layer_wall)		
	cells_start = map.get_used_cells(layer_start)
	cells_finish = map.get_used_cells(layer_finish)
	
	
	start_coords = map.get_cell_atlas_coords(layer_start,cells_start[0])
	stop_coords = map.get_cell_atlas_coords(layer_finish,cells_finish[0])

	#map.set_layer_enabled(GameParams.layer_finish,false)
	for coords in cells_finish:
		map.set_cell(layer_finish,coords,tileset_source_id,start_coords)
	
		
	for wall in cells_wall:
		if wall.x < world_min_cell.x: world_min_cell.x = wall.x
		if wall.y < world_min_cell.y: world_min_cell.y = wall.y
		if wall.x > world_max_cell.x: world_max_cell.x = wall.x
		if wall.y > world_max_cell.y: world_max_cell.y = wall.y
	
	world_min_cell -= Vector2i(1,1)
	world_max_cell += Vector2i(1,1)
	
	world_min = map.map_to_local(world_min_cell)
	world_max = map.map_to_local(world_max_cell)
	
	#if true:
		#viewport.limit_left = world_min.x
		#viewport.limit_top = world_min.y 
		#viewport.limit_right = world_max.x
		#viewport.limit_bottom = world_max.y
	#
	
	
	alive = true
	GameManager.is_moving=false
	if tween: tween.kill()
	
	var start_pos = map.map_to_local(cells_start[0])
	
	
	#tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	#tween.set_loops(1).set_parallel(false)
	#tween.tween_property(self, "position", start_pos, 0)	
	position = start_pos
	
	var foods = get_tree().get_nodes_in_group("food") 
	total_poops=0
	for food in foods:
		food.connect("body_entered", func(body): collide_food(body,food))
		total_poops += food.get_potency()

# Called every frame
func _process(delta):
	#$Camera2D.custom_viewport = Vector2(128,128)
	UI.update_lifes(GameManager.num_lifes)
	UI.update_poops(poop_counter)
	UI.update_flys(fly_ingame)
	
	if alive:
		PlayerMovement(delta)
		PlayerAnimation()
	
	update_finish()
	
	check_win()
		
func update_finish():
	var complete = can_win()
	if can_finish: return true
	if can_finish == complete: return true
	can_finish = complete 
	#map.set_layer_enabled(GameParams.layer_finish,true)
	for coords in cells_finish:
		map.set_cell(GameParams.layer_finish,coords,GameParams.tileset_source_id,stop_coords)
		
	get_tree().create_timer(0.2).timeout.connect(Sfx.success)

func can_win():
	var foods = get_tree().get_nodes_in_group("food") 
	if len(foods) > 0: 
		return false
	if poop_counter > 0: 
		return false
	
	return true
		
func check_win():
	var cur_cell = map.local_to_map(position)
	#if (last_cell == cur_cell): return false
	#last_cell = cur_cell
		
	if not cells_finish.has(cur_cell): return false	
	if not can_win(): return
	
	print("you win")
	next()
	return true
		
		
func can_walk(coords):
	var is_wall = cells_wall.has(coords)
	var is_entrance = cells_start.has(coords)
	var is_exit = cells_finish.has(coords)
	#print(coords)
	var blocked = is_wall or is_entrance or ( is_exit and !can_win() )
	return not blocked

func PlayerMovement(delta):
	if GameManager.is_moving: return
	
	# GAMEMANAGER
	var cur_pos = position
	var cur_coords = map.local_to_map(cur_pos)
	var next_coords = cur_coords + GameManager.step
	# GAMEMANAGER
	
	var walkable = can_walk(next_coords) #cells_wall.has(next_coords)
	
	if GameManager.step == Vector2i.ZERO: return 
			
	if not GameManager.is_moving and walkable:

		GameManager.is_moving = true
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
			GameManager.is_moving = false
			GameManager.step = Vector2i.ZERO
			
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
	total_poops -= 1
	UI.update_poops(poop_counter)
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
		
	if (GameManager.is_moving):
		PlayerAnim.play("walk_" + direction)
	else:
		PlayerAnim.play("idle_" + direction)
	
func collide_fly(body, fly):
	if body != self: return
	print("omg a pooped fly!", body)
	death()
		
	
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
	if not alive: return
	alive = false
	PlayerAnim.play("death")
	Sfx.death()
	await get_tree().create_timer(0.8).timeout
	await level_title.to_white()
	GameManager.num_lifes -= 1
	
	await reset()
	if GameManager.num_lifes == 0:
		GameManager.LoadGameOver()
		
	
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


func _player_animation_finished():
	pass # Replace with function body.
