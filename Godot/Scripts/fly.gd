extends RigidBody2D

@onready var FlyAnimmation = get_node("AnimatedSprite2D")

var action_stay = 0.25
var action_poop = 0.25
var action_move = 0.5
var move_dist = [50,100]
var action_duration = [2,5]

var tween
var rng = RandomNumberGenerator.new()

func goto_target_poop(poop, time):
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(false)
	tween.tween_property(self, "position", poop.position, time)
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
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

