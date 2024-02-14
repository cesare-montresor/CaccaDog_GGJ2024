extends Node2D

#@export var healthBar : ProgressBar
#@export var xpBar : ProgressBar
#@export var levelLabel : Label
#@export var damageLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	setUp()

func setUp():
	$Player.position = PlayerState.lastPosition
	
	#healthBar.max_value = PlayerState.maxHealth
	#healthBar.value = PlayerState.health
	
	#xpBar.value = PlayerState.xp
	#xpBar.max_value = PlayerState.xpNeeded
	#levelLabel.text = "LVL: " + str(PlayerState.level)
	#damageLabel.text = "DMG: " + str(PlayerState.damage)

