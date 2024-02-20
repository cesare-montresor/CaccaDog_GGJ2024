class_name Fly extends Area2D

# game params
var fly_speed = GameParams.fly_speed

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
var is_moving = false
var next_action = 0
var map
var player
var fly_num=0
@onready var FlyAnimmation = get_node("AnimatedSprite2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select_action()
	pass



func _ready():
	var action_sum = action_poop + action_move + action_follow
	
	action_poop = action_poop / action_sum
	action_move = action_move / action_sum
	action_follow = action_follow / action_sum
	
	action_move += action_poop
	action_follow += action_move
	
	spawn_min = player.world_min_cell 
	spawn_max = player.world_max_cell 
	
	spawn_fly()
	

func spawn_fly():
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

func TimeNow():
	return Time.get_unix_time_from_system()

func sleep(timeout):	
	next_action = TimeNow() + timeout

func canMove():	
	return TimeNow() > next_action

func goto_target_poop(poop):
	print(fly_num,' fly: poop', poop.position)
	goto_position(poop.position)
	
func goto_position(dst_position):
	var distance = position.distance_to(dst_position)
	var fly_time = distance / fly_speed
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", dst_position, fly_time)
	sleep(fly_time)
	Sfx.buzz()
	AnimateFly(dst_position)
	

	
func goto_stay(timeout):
	FlyAnimmation.play("idle_d")
	sleep(timeout)
	

func select_action():
	if not canMove(): return
	tween.kill()
	var action_prob = rng.randf()
	print('action_prob',action_prob)
	if (action_prob < action_poop):
		var poops = get_tree().get_nodes_in_group("poop") 
		var target_poop = poops.pick_random()
		var cooldown = rng.randf_range(action_cooldown[0],action_cooldown[1])
		print(fly_num,' fly: poop', target_poop.position, cooldown)
		goto_position(target_poop.position)
		goto_stay(cooldown)
		
	elif (action_prob < action_move):
		var off_x = rng.randi_range(move_dist[0],move_dist[1])
		var off_y = rng.randi_range(move_dist[0],move_dist[1])
		var target_cell = map.local_to_map(position) + Vector2i(off_x,off_y)
		var target_position = map.map_to_local(target_cell)
		print(fly_num,' fly: move', target_position )
		goto_position(target_position)
	else:
		print(fly_num,' fly: follow', player.position)
		goto_position(player.position)
	
	
func AnimateFly(target_position):
	var cd = position - target_position
	var dir
	if abs(cd.x)>abs(cd.y):
		dir = 'l' if cd.x > 0 else 'r'
	else:
		dir = 'u' if cd.y > 0 else 'd'
	
	FlyAnimmation.play("idle_" + dir)
	
