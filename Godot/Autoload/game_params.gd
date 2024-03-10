extends Node

# MUSIC SFX ON/OFF
const sound = true
const tile_size = 16

# Map
const layer_background = 0
const layer_wall = 1
const layer_start = 2
const layer_finish = 3

# Player
const num_lifes = 3
const step_speed = 0.200
const step_delay = 0.015
const initial_poop_count : int = 0


# fly
const poops_per_fly : int = 4

const fly_speed : int = 40

const fly_action_poop : float = 0.3
const fly_action_move : float = 0.3
const fly_action_follow : float = 0.5

const fly_action_cooldown = [1,1]

const fly_action_move_dist = [3,3]
const fly_action_follow_dist = [2,5]

