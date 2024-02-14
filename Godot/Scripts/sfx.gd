extends Node

#@export var Accept : AudioStreamPlayer
#@export var Cancel : AudioStreamPlayer
#@export var Interact : AudioStreamPlayer
@export var Eat : AudioStreamPlayer
@export var Fart1 : AudioStreamPlayer
@export var Fart2 : AudioStreamPlayer
@export var Fart3 : AudioStreamPlayer
@export var Fart4 : AudioStreamPlayer
@export var Fart5 : AudioStreamPlayer
@export var Fart6 : AudioStreamPlayer
@export var Fart7 : AudioStreamPlayer
@export var Fart8 : AudioStreamPlayer
@export var Fart9 : AudioStreamPlayer
@export var Fart10 : AudioStreamPlayer
@export var Fart11 : AudioStreamPlayer
@export var Fart12 : AudioStreamPlayer
@export var Fart13 : AudioStreamPlayer
@export var Fart14 : AudioStreamPlayer
#@export var Hit : AudioStreamPlayer
@export var Death : AudioStreamPlayer
#@export var PickUp : AudioStreamPlayer
#@export var Win : AudioStreamPlayer

@onready var farts = [Fart1,Fart2,Fart3,Fart4,Fart5,Fart6,Fart7,Fart8,Fart9,Fart10,Fart11,Fart12,Fart13,Fart14]
@onready var eats = [Eat]

func eat():
	if not GameParams.sound:
		return
	eats.pick_random().play()
	
func fart():
	if not GameParams.sound:
		return
	farts.pick_random().play()
	
func death():
	if not GameParams.sound:
		return
	Death.play()
