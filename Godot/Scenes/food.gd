extends Area2D

static var food_potency = [1,3,5,11]

@onready var food_sprites = [$food_0, $food_1, $food_2, $food_3]

var food_level = 0

func set_potency(level):
	if(level>len(food_potency)): level = len(food_potency) - 1
	if(level<0): level = 0
	for sprite in food_sprites: sprite.visible = false
	food_sprites[level].visible = true
	food_level = level
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
