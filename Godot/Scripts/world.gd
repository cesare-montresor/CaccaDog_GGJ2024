extends Node2D

#@export var healthBar : ProgressBar
#@export var xpBar : ProgressBar
#@export var levelLabel : Label
#@export var damageLabel : Label

# Loading Characters for Dialogic
@onready var Player = load("res://Dialogic/Characters/Player.dch")
#@onready var Antonio = load("res://Dialogic/Characters/Antonio.dch")

# Called when the node enters the scene tree for the first time.
func _ready():
	setUp()
	
	# Connect Signals from Dialogic
	#Dialogic.signal_event.connect(_on_dialogic_signal)


func setUp():
	$Player.position = PlayerState.lastPosition
	
	#healthBar.max_value = PlayerState.maxHealth
	#healthBar.value = PlayerState.health
	
	#xpBar.value = PlayerState.xp
	#xpBar.max_value = PlayerState.xpNeeded
	#levelLabel.text = "LVL: " + str(PlayerState.level)
	#damageLabel.text = "DMG: " + str(PlayerState.damage)


func _on_antonio_body_entered(body):
	if body.is_in_group("Player"):
		print("Hey Antonio!")
		if Dialogic.current_timeline == null:
			var layout = Dialogic.start('Antonio')
			layout.register_character(Player, $Player)
			#layout.register_character(Antonio,$Antonio )


func _on_antonio_body_exited(body):
	if body.is_in_group("Player"):
		print("Bye Antonio!")


func _on_gate_body_entered(body):
	if !body.is_in_group("Player"):
		return
	else:
		print("Gate!")
		if Dialogic.current_timeline == null:
			var layout = Dialogic.start('LookMore')
			layout.register_character(Player, $Player)

func _on_dialogic_signal(argument:String):
	if argument == "RemoveGate":
		print("Removing Gate")
		$Gate.queue_free()


func _on_cacca_body_entered(body):
	pass # Replace with function body.
