extends Node2D

const CAMERA_RES = preload("res://Scenes/camera_manager.tscn")

@onready var map: TileMap = $TileMap as TileMap

var cells_wall
var cells_start
var cells_finish
var camera

var world_min = Vector2i(0,0) 
var world_max = Vector2i(0,0) 

var world_min_cell = Vector2i(0,0) 
var world_max_cell = Vector2i(0,0) 


func _ready():
	camera = CAMERA_RES.instantiate()
	add_child(camera)
	var window_size = Vector2i(GameParams.window_width,GameParams.window_height)
	get_viewport().get_window().min_size = window_size
	
	var layer_wall = GameParams.layer_wall
	var layer_start = GameParams.layer_start
	var layer_finish = GameParams.layer_finish
	
	cells_wall = map.get_used_cells(layer_wall)
	cells_start = map.get_used_cells(layer_start)
	cells_finish = map.get_used_cells(layer_finish)
		
	for wall in cells_wall:
		if wall.x < world_min_cell.x: world_min_cell.x = wall.x
		if wall.y < world_min_cell.y: world_min_cell.y = wall.y
		if wall.x > world_max_cell.x: world_max_cell.x = wall.x
		if wall.y > world_max_cell.y: world_max_cell.y = wall.y
	
	var camera_world_margin = 6
	world_min_cell += Vector2i.ONE * camera_world_margin
	world_max_cell -= Vector2i.ONE * camera_world_margin
	
	world_min = map.map_to_local(world_min_cell)
	world_max = map.map_to_local(world_max_cell)
	
	
	camera_to_center()
	camera.reset_smoothing()
	

func _process(delta):
	camera_to_player()
	
	
func camera_to_player():
	var pos = $Player.position 
	var px = clamp(pos.x,world_min.x,world_max.x)
	var py = clamp(pos.y,world_min.y,world_max.y)
	if px == pos.x and py == pos.y:
		camera.position = pos
	
func camera_to_center():
	var cx = (world_min.x + world_max.x) / 2
	var cy = (world_min.y + world_max.y) / 2
	var pos = Vector2(cx,cy)
	camera.position = pos
	
	
	
	
	
