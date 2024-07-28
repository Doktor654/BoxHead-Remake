extends Path2D


var zombies : Array = [preload("res://scener/Enemies/zombie_1.tscn"), preload("res://scener/Enemies/zombie_2.tscn")]


func _ready():
	randomize()
	Global.wave = 1
	Global.max_zombies = 15
	Global.wave_on = true

func _process(delta):
	if Global.zombies_killed == Global.max_zombies:
		change_wave()

func spawn_zombie1():
	if Global.wave_on and Global.zombies_spawned < Global.max_zombies:
		var rng = RandomNumberGenerator.new()
		$PathFollow2D.progress = rng.randi_range(0, 3889)
		var z = zombies[0].instantiate()
		get_tree().current_scene.get_node("Enemies").add_child(z)
		z.global_position = $PathFollow2D/Marker2D.global_position
		Global.zombies_spawned += 1
		print(Global.zombies_spawned)
		
		
func spawn_zombie2():
	if Global.wave_on and Global.zombies_spawned < Global.max_zombies and Global.wave >= 2:
		var rng = RandomNumberGenerator.new()
		$PathFollow2D.progress = rng.randi_range(0, 2158)
		var z = zombies[1].instantiate()
		get_tree().current_scene.get_node("Enemies").add_child(z)
		z.global_position = $PathFollow2D/Marker2D.position
		Global.zombies_spawned += 1
		print(Global.zombies_spawned)


		
func change_wave():
	Global.wave += 1
	Global.max_zombies += 30
	Global.zombies_spawned = 0
	Global.zombies_killed = 0

func _on_zombie_1_spawn_timer_timeout():
	spawn_zombie1()



func _on_zombie_2_spawn_timer_timeout():
	spawn_zombie2()
