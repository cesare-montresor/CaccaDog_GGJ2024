extends Node

const levels = [
	"res://Levels/KnowYourEnemy.tscn",
	"res://Levels/LearnToCount.tscn",
	"res://Levels/BreakTheLoop.tscn",
	"res://Levels/RightPath.tscn",
	"res://Levels/LongWayHome.tscn",
	"res://Levels/LongTail.tscn",
	"res://Levels/PossibleIndigestion.tscn",
	"res://Levels/VeryLongTail.tscn"
]

const levels_cnt = len(levels)


var tree:Node
var current_level = 0

func LoadLevel(level_num):
	if level_num < 0: level_num = 0
	if level_num >= levels_cnt: level_num = levels_cnt - 1
	
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

