extends Node

# MUSIC SFX ON/OFF
const sound = true

# Map
const layer_background = 0
const layer_wall = 1
const layer_start = 2
const layer_finish = 3

# Player
const step_speed = 0.200
const step_delay = 0.022
const initial_poop_count : int = 0


# fly
const poops_per_fly : int = 3

const fly_speed : int = 50
const fly_action_follow : float = 4.0
const fly_action_stay : float = 1.0
const fly_action_poop : float = 1.0
const fly_action_move : float = 1.0
const fly_action_cooldown = [0.5,0.5]

const fly_action_move_dist = [2,4]

