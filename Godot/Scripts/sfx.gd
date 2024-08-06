extends Node

var rng = RandomNumberGenerator.new()
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
@export var FlyBuzzingStereo : AudioStreamPlayer
@export var FlyBuzzingMono : AudioStreamPlayer
@export var Success : AudioStreamPlayer

@onready var farts = [Fart1,Fart2,Fart3,Fart4,Fart5,Fart6,Fart7,Fart8,Fart9,Fart10,Fart11,Fart12,Fart13,Fart14]
@onready var eats = [Eat]

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = Time.get_unix_time_from_system()

func eat():
	if not GameParams.sound: return
	eats.pick_random().play()
	
func fart():
	if not GameParams.sound and rng.randi_range(0,199)!=42: return
	farts.pick_random().play()
	
func death():
	if not GameParams.sound: return
	Death.play()

func buzz():
	if not GameParams.sound: return
	FlyBuzzingStereo.play()

func success():
	if not GameParams.sound: return
	Success.play()
