class_name Fly extends Area2D

# game params
var fly_speed = GameParams.fly_speed
var action_stay = GameParams.fly_action_stay
var action_poop = GameParams.fly_action_poop
var action_move = GameParams.fly_action_move
var action_follow = GameParams.fly_action_move
var move_dist = GameParams.fly_action_move_dist
var action_cooldown = GameParams.fly_action_cooldown



# fly vars
var spawn_min = Vector2i(0,0) 
var spawn_max = Vector2i(0,0) 
var tween
var rng = RandomNumberGenerator.new()

var map
var player
@onready var FlyAnimmation = get_node("AnimatedSprite2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _ready():
	var action_sum = action_stay + action_poop + action_move + action_follow
	action_stay = action_stay / action_sum
	action_poop = action_poop / action_sum
	action_move = action_move / action_sum
	action_follow = action_follow / action_sum
	
	action_poop += action_stay
	action_move += action_poop
	action_follow += action_move
	
	
	var cells_wall = map.get_used_cells(GameParams.layer_wall)		
	for wall in cells_wall:
		if wall.x < spawn_min.x: spawn_min.x = wall.x
		if wall.y < spawn_min.y: spawn_min.y = wall.y
		if wall.x > spawn_max.x: spawn_max.x = wall.x
		if wall.y > spawn_max.y: spawn_max.y = wall.y
	spawn_min -= Vector2i(1,1)
	spawn_max += Vector2i(1,1)
	
	spwan()
	

func spwan():
	var spawn_x = rng.randf_range(spawn_min.x, spawn_max.x)
	var spawn_y = rng.randf_range(spawn_min.y, spawn_max.y)
	var spawn_cell = Vector2i(spawn_x, spawn_y)
	var spwan_border = rng.randi_range(0,3) 
	match spwan_border:
		0: spawn_cell.x = spawn_min.x
		1: spawn_cell.y = spawn_min.y
		2: spawn_cell.x = spawn_max.x
		3: spawn_cell.y = spawn_max.y
	var spawn_pos = map.map_to_local(spawn_cell)
	position = spawn_pos



func goto_target_poop(poop):
	goto_position(poop.position)

func goto_caccadog(player):
	goto_position(player.position)
	
func goto_position(target_position):
	var distance = position.distance_to(target_position)
	var fly_time = distance / fly_speed
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", target_position, fly_time)
	tween.tween_callback(select_action)
	AnimateFly(target_position)
	
func goto_stay(timeout):
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", position, timeout)
	tween.tween_callback(select_action)
	FlyAnimmation.play("idle_u")
	

func select_action():
	tween.kill()
	var action_prob = rng.randf()
	
	var target_position = null
	if (action_prob < action_stay):
		var cooldown = rng.randi_range(action_cooldown[0],action_cooldown[1])
		goto_stay(cooldown)
	elif (action_prob < action_poop):
		var poops = get_tree().get_nodes_in_group("poop") 
		var target_poop = poops.pick_random()
		goto_position(target_poop.position)
	elif (action_prob < action_move):
		var rnd_dist = rng.randi_range(move_dist[0],move_dist[1])
		var rnd_angle = rng.randf_range(0, 2*3.1415)
		var delta_pos = Vector2( sin(rnd_angle),cos(rnd_angle))*rnd_dist
		target_position = position + delta_pos # stroll
	else:
		goto_position(player.position)
	
	
func AnimateFly(target_position):
	var cd = position - target_position
	var dir
	if abs(cd.x)>abs(cd.y):
		dir = 'l' if cd.x > 0 else 'r'
	else:
		dir = 'u' if cd.y > 0 else 'd'
	
	FlyAnimmation.play("idle_" + dir)
	
