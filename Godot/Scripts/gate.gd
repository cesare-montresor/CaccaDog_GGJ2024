@tool
extends Area2D

@onready var gate_open =  $gate_open
@onready var gate_close = $gate_closed
@onready var gate_label = $gate_label


@export var is_open = true
@export var is_entrance = true

	
# Called when the node enters the scene tree for the first time.
func _ready():
	update_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_sprite()
		
func can_walk():
	if not is_entrance: return is_open
	return false
		
func update_sprite():
	gate_label.visible = Engine.is_editor_hint()
	gate_label.text = 'IN' if is_entrance else 'OUT'
	gate_open.visible = is_open
	gate_close.visible = not is_open
