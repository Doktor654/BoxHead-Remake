extends Node

var player
var Players = {}
var current_weapon
var Camera : Camera2D
var money : int = 10000
var modes : Array = ["solo", "multiplayer"]
var mode : int

#Wave grejer
var wave:int = 0
var wave_on: bool = false
var zombies_killed : int = 0
var zombies_spawned : int = 0
var max_zombies: int


#signals
signal wave_changed
