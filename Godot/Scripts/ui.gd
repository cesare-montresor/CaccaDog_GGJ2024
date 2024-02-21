extends CanvasLayer


var life1
var life2
var life3
var lifes = []


func update_lifes(lifes_num):
	for i in range(len(lifes)):
		print("update_lifes ",lifes_num, ' ', i,' ', i <= lifes_num)
		lifes[i].visible = (lifes_num >= i+1)

# Called when the node enters the scene tree for the first time.
func _ready():
	life1 = $DogLifeCount/HBoxContainer/life1
	life2= $DogLifeCount/HBoxContainer/life2
	life3= $DogLifeCount/HBoxContainer/life3
	lifes = [life1,life2,life3]

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
