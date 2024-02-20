extends CanvasLayer


@export var life1: TextureRect 
@export var life2 = TextureRect
@export var life3 = TextureRect
@onready var lifes = [life1,life2,life3]


func update_lifes(lifes_num):
	for i in range(len(lifes)):
		print("update_lifes ",lifes_num, ' ', i,' ', i <= lifes_num)
		lifes[i].visible = (lifes_num > i)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
