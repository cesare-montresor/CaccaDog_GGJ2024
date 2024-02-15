extends AudioStreamPlayer

@export var soundtrack : Resource = preload("res://Assets/Audio/music/Three Red Hearts - Deep Blue.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = soundtrack
	playing = GameParams.sound

