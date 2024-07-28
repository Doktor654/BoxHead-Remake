extends Node2D

var zombie_amount : int = 0

var zombies : Array = [preload("res://scener/Enemies/zombie_1.tscn"), preload("res://scener/Enemies/zombie_2.tscn")]
@export var spawner : PackedScene
var zombi1_wait_time = 2
@export var spawn_pos_x : int
@export var spawn_pos_y : int

@onready var pause_timer = $PauseTimer

@export var zombie1_spawn_node : Node2D
@onready var zombie1_spawner = $ZombieSpawner
#@onready var zombie2_spawner = $Zombie2Spawner

var paused : bool = false

func _ready():
	Global.wave = 1
	Global.max_zombies = 15
	Global.wave_on = true
	zombie1_spawner.spawn_path = get_path()
	#zombie2_spawner.spawn_path = get_path()
	
func _process(delta):
	$ZombieSpawnTimer.set_wait_time(zombi1_wait_time)
	if Global.zombies_killed == Global.max_zombies:
		if !paused:
			pause_timer.start()
			print("START TIMER")
			$Pause_ticking.play()
			paused = true
		

@rpc("any_peer")
func _on_zombie_spawn_timer_timeout():
	spawn_pos_x = randi_range(0, 1920)
	spawn_pos_y = randi_range(0, 1080)
	if Global.wave_on and Global.zombies_spawned < Global.max_zombies:
		if is_multiplayer_authority():
			call_deferred("spawn_zombi1", spawn_pos_x, spawn_pos_y)
		#spawn_zombi1(spawn_pos_x, spawn_pos_y)
	
@rpc("any_peer")
func change_wave():
	Global.wave += 1
	Global.max_zombies += 15
	Global.zombies_spawned = 0
	Global.zombies_killed = 0
	if Global.wave >= 2 and Global.wave <= 5:
		zombi1_wait_time = 1.2
	if Global.wave >= 5:
		zombi1_wait_time = .9

@rpc("any_peer")
func _on_explo_zombie_timer_timeout():
	spawn_pos_x = randi_range(0, 1920)
	spawn_pos_y = randi_range(0, 1080)
	if Global.wave_on and Global.zombies_spawned < Global.max_zombies and Global.wave >= 2:
		if is_multiplayer_authority():
			call_deferred("spawn_zombi2", spawn_pos_x, spawn_pos_y)


func spawn_zombi1(x, y):
	var z = zombies[0].instantiate()
	z.position.x = x
	z.position.y = y
	#get_parent().get_node("Enemies").add_child(z, true)
	add_child(z, true)
	Global.zombies_spawned += 1
	print(Global.zombies_spawned)

func spawn_zombi2(x, y):
	var z = zombies[1].instantiate()
	z.position.x = randi_range(0, 1920)
	z.position.y = randi_range(0, 1080)
	add_child(z, true)
	Global.zombies_spawned += 1



func _on_pause_timer_timeout():
	print("done")
	Global.wave_changed.emit()
	change_wave()
	paused = false
