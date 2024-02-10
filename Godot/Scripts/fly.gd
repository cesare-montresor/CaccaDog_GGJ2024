class_name Fly extends Area2D

@onready var FlyAnimmation = get_node("AnimatedSprite2D")
const fly_asset = preload("res://Scenes/fly.tscn")

var action_stay = GameParams.action_stay
var action_poop = GameParams.action_poop
var action_move = GameParams.action_move
var move_dist = GameParams.move_dist
var action_duration = GameParams.action_duration

var fly_spwan_dist = GameParams.fly_spwan_dist
var fly_time_poop = GameParams.fly_time_poop


var tween
var rng = RandomNumberGenerator.new()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _ready():
	var action_sum = action_stay + action_poop + action_move
	action_stay = action_stay / action_sum
	action_poop = action_poop / action_sum
	action_move = action_move / action_sum

func add_fly():
	var new_fly = fly_asset.instantiate()
	var radius = rng.randf_range(fly_spwan_dist[0],fly_spwan_dist[1])
	var angle = rng.randf_range(0, 2 * 3.1415)
	var pos = Vector2( cos(angle), sin(angle) ) * radius
	new_fly.position = pos
	return new_fly



func goto_target_poop(poop):
	var fly_time = rng.randf_range(fly_time_poop[0],fly_time_poop[1])
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", poop.position, fly_time)
	tween.tween_callback(select_action)

func select_action():
	tween.kill()
	var action_prob = rng.randf()
	
	var target_position = null
	if (action_prob < action_stay):
		target_position = position # stay
	elif (action_prob < action_stay + action_poop):
		var poops = get_tree().get_nodes_in_group("poop") 
		var target_poop = poops.pick_random()
		target_position = target_poop.position # to other poop
	else:
		var rnd_dist = rng.randi_range(move_dist[0],move_dist[1])
		var rnd_angle = rng.randf_range(0, 2*3.1415)
		var delta_pos = Vector2( sin(rnd_angle),cos(rnd_angle))*rnd_dist
		target_position = position + delta_pos # stroll
		
	var rnd_dur = rng.randi_range(action_duration[0],action_duration[1])
	
	
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", position, 0)
	tween.tween_property(self, "position", target_position, rnd_dur)
	tween.tween_callback(select_action)
	AnimateFly(target_position)
	
	
	
func AnimateFly(target_position):
	var cd = position - target_position
	var dir
	if abs(cd.x)>abs(cd.y):
		dir = 'l' if cd.x > 0 else 'r'
	else:
		dir = 'u' if cd.y > 0 else 'd'
	
	FlyAnimmation.play("idle_" + dir)
	
