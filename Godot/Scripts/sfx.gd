extends Node

#@export var Accept : AudioStreamPlayer
#@export var Cancel : AudioStreamPlayer
#@export var Interact : AudioStreamPlayer
@export var Fart1 : AudioStreamPlayer
@export var Fart2 : AudioStreamPlayer
@export var Fart3 : AudioStreamPlayer
#@export var Hit : AudioStreamPlayer
@export var Death : AudioStreamPlayer
#@export var PickUp : AudioStreamPlayer
#@export var Win : AudioStreamPlayer

@onready var farts = [Fart1,Fart2,Fart3]

func fart():
	farts.pick_random().play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
