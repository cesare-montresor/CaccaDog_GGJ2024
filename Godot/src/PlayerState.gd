extends Node

const resetPosition : Vector2 = Vector2(0, 0)
var lastPosition : Vector2 = Vector2(0, 0)

var maxHealth = 35
var health = maxHealth
var damage = 10
var level = 1
var xp = 0
var xpNeeded = 0 #amount of xp to level up


func _ready():
	xpNeeded = getRequiredXP(level + 1) #ready for next level

func getRequiredXP(level):
	return round(pow(level, 1.8) + level * 4)

func upgradeStats():
	var chance = randi_range(0, 1)
	
	# increase Health OR Damage with level up
	if chance == 0:
		maxHealth += 1
	else:
		damage += 1


