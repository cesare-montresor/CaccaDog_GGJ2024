extends Node

const levels = [
	"res://Scenes/L01_tutorial.tscn",
	"res://Scenes/L02.tscn",
	"res://Scenes/L03.tscn",
	"res://Scenes/L04.tscn",
]

const levels_cnt = len(levels)


var tree:Node
var current_level = 0

func LoadLevel(level_num):
	if level_num < 0: level_num = 0
	if level_num >= levels_cnt: level_num = levels_cnt
	
	var level_res = levels[level_num]
	get_tree().change_scene_to_file(level_res)
	
	current_level = level_num
	return current_level
	
func ReloadLevel():
	return LoadLevel(current_level)
	
func NextLevel():
	return LoadLevel(current_level+1)
	
func PrevLevel():
	return LoadLevel(current_level-1)
