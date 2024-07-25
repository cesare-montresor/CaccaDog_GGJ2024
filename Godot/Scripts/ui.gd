extends CanvasLayer


var life1: TextureRect
var life2: TextureRect
var life3: TextureRect
var life4: TextureRect
var lifes = []
var poops_lbl: Label
var flys_lbl: Label

func update_lifes(lifes_num):
	for i in range(len(lifes)):
		#print("update_lifes ",lifes_num, ' ', i,' ', i <= lifes_num)
		lifes[i].modulate.a  = 1 if (lifes_num >= i+1) else 0.3
		
func update_poops(poops_num):
	poops_lbl.text = ("x" if poops_num>9 else 'x0') + str(poops_num)
	
func update_flys(flys_num):
	flys_lbl.text = ("x" if flys_num>9 else 'x0') + str(flys_num)

# Called when the node enters the scene tree for the first time.
func _ready():
	life1 = $DogLifeCount/HBoxContainer/life1
	life2= $DogLifeCount/HBoxContainer/life2
	life3= $DogLifeCount/HBoxContainer/life3
	life4= $DogLifeCount/HBoxContainer/life4
	lifes = [life1,life2,life3,life4]
	poops_lbl = $Annoiance/HBoxContainer/CaccaToGo
	flys_lbl = $Annoiance/HBoxContainer/FlyCount
	
	#remove_child(controls_touchs)
	#add_child(controls_touchs)
	#controls_touchs.top_level=false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	controls_touchs.top_level=false
	controls_touchs.top_level=true
	pass
