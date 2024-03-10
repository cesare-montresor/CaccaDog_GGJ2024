extends Node

const menu_path = "res://Scenes/menu.tscn"
const game_over_path = "res://Scenes/game_over.tscn"
const credits_path = "res://Scenes/credits.tscn"

const levels_path = "res://Levels/"

var levels = []
var levels_cnt = len(levels)

var num_lifes
var tree:Node
var current_level = 0

func _init():
	var files = Array(DirAccess.get_files_at(levels_path))
	var match_level = RegEx.new()
	match_level.compile("[0-9][0-9]_.*\\.tscn")
	files=files.filter(func(path): return len(match_level.search_all(path) ) > 0 )
	files.sort()
	levels=files
	levels_cnt = len(levels)
	print(levels)
	
	num_lifes = GameParams.num_lifes

func LoadLevel(level_num):
	if level_num < 0: level_num = 0
	if level_num >= levels_cnt: level_num = levels_cnt - 1
	
	var level_res = levels[level_num]
	get_tree().change_scene_to_file(levels_path+level_res)
	
	current_level = level_num
	return current_level

func StartLevel():
	return LoadLevel(0)

func ReloadLevel():
	return LoadLevel(current_level)
	
func NextLevel():
	return LoadLevel(current_level+1)
	
func PrevLevel():
	return LoadLevel(current_level-1)
	
func LoadGameOver():
	get_tree().change_scene_to_file(game_over_path)
	
func LoadMenu():
	get_tree().change_scene_to_file(menu_path)

func LoadCredits():
	get_tree().change_scene_to_file(credits_path)
	


