extends CharacterBody2D

class_name Zombie

var spawnables: Array = [preload("res://scener/Random shit/hp_pack.tscn")]
var blood = preload("res://scener/Random shit/blood.tscn")
@export var popup_scene : PackedScene

@export var speed = 75
@export var price : int
var player_chase = false
var closest_player = null
var closest_player_distance = 0.0

@export var dmg = 20
@export var hp = 50
var dir : Vector2
var can_attack : bool = false
var arean
var dead : bool

@rpc("any_peer")
func _ready():
	dead = false
	$AnimationPlayer.play("come_up")
	for wave in Global.wave:
		hp += 10
		

@rpc("any_peer")
func _physics_process(delta):
	if Global.mode == 0:
		if player_chase:
			#position += (Global.player.position - position) /speed
			#position += position.direction_to(Global.player.position) * speed * delta
			dir = to_local($NavigationAgent2D.target_position).normalized()
			velocity = dir * speed
			$AnimationPlayer.play("Walk")
			move_and_slide()
			#if(Global.player.position.x - position.x) < 0:
				#scale.x = -1.5
			#else:
				#scale.x = 1.5
			
			if(Global.player.position.x - position.x) < 0:
				$Sprite2D.flip_h = true
				$Eye1.position = Vector2(-8.75, -33.75)
				$Eye2.position = Vector2(2.5, -33.75)
			else:
				$Sprite2D.flip_h = false
				$Eye1.position = Vector2(-2.5, -33.75)
				$Eye2.position = Vector2(8.75, -33.75)
	elif Global.mode == 1:
		var players = get_parent().get_parent().get_node("Players").get_children()
		if player_chase:
			for playern in Global.Players:
				for playert in players:
					if playert.name == str(playern):
						playern = playert
						#print("player hittad!")
					
						var current_player_distance = position.distance_to(playern.position)
						if closest_player == null or current_player_distance < closest_player_distance:
							closest_player = playern
							#print(closest_player.position)
							closest_player_distance = current_player_distance
						
				
			position += position.direction_to(closest_player.position) * speed * delta
			#print("Går till: ", closest_player)
			$AnimationPlayer.play("walk")
			
			if(closest_player.position.x - position.x) < 0:
				scale.x = 1
				$Eye1.position = Vector2(-2.5, -33.75)
				$Eye2.position = Vector2(8.75, -33.75)
			else:
				scale.x = -1
				$Eye1.position = Vector2(-8.75, -33.75)
				$Eye2.position = Vector2(-2.5, -33.75)
func _process(delta):
	$Test_HP.text = str(hp)
	if can_attack:
		$AnimationPlayer.play("attack")
		
	if hp <= 0 and player_chase:
		player_chase = false
		die()

@rpc("any_peer")
func hit(dmg, pos):
	hp -= dmg
	var b = blood.instantiate()
	get_parent().get_parent().add_child(b)
	b.global_position = global_position
	b.rotation = Global.player.position.angle_to_point(position)
	#knockback(pos)
	
func die():
	$AnimationPlayer.play("Die")
	$CollisionShape2D.disabled = true
	$HitArea/CollisionShape2D.disabled = true
	dead = true
	PopUp()
	if $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()



func _on_hit_area_area_entered(area):
	if area.is_in_group("Gubbe"):
		player_chase = false
		can_attack = true
		arean = area



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Die":
		ta_bort()
	if anim_name == "attack":
		pass
	if anim_name == "come_up":
		player_chase = true

func knockback(damage_source_pos:Vector2):
	var knockback_direction = damage_source_pos.direction_to(self.position)
	var knockback = knockback_direction * 10
	position += knockback


func _on_hit_area_area_exited(area):
	if area.is_in_group("Gubbe"):
		player_chase = true
		can_attack = false
		arean = null
func spawn_heal():
	var hp = spawnables[0].instantiate()
	hp.position = position
	get_tree().current_scene.add_child(hp)

@rpc("call_local")
func ta_bort():
	if Global.mode == 0:
		var rand_numb = randi_range(1, 20)
		if rand_numb == 1:
			spawn_heal()
		#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
		queue_free()
	if Global.mode == 1:
		if is_multiplayer_authority():
			Global.zombies_killed += 1
			#print("zombies Killed: ", Global.zombies_killed)
			Global.money += price
			var rand_numb = randi_range(1, 20)
			if rand_numb == 1:
				spawn_heal()
			#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
			rpc("sync_ta_bort")
			queue_free()
			
		else:
			rpc("sync_ta_bort")
			
@rpc("any_peer")
func sync_ta_bort():
	if !is_multiplayer_authority():
		Global.zombies_killed += 1
		#print("zombies Killed: ", Global.zombies_killed)
		Global.money += price
		var rand_numb = randi_range(1, 5)
		if rand_numb == 1:
			spawn_heal()
		#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
		queue_free()
	else:
		pass
	
func hit_player():
	arean.get_parent().hit(dmg)
	print("hit")

func PopUp():
	if Global.mode == 0:
		var p = popup_scene.instantiate()
		p.position = $PopUpLocation.global_position
		add_child(p)
		Global.zombies_killed += 1
		Global.money += price
		
		


func _on_sound_area_area_entered(area):
	if area.is_in_group("Gubbe"):
		if !dead:
			$AudioStreamPlayer2D.play()
		


func _on_sound_area_area_exited(area):
	if area.is_in_group("Gubbe"):
		$AudioStreamPlayer2D.stop()

func make_path():
	$NavigationAgent2D.target_position = Global.player.position
	#print($NavigationAgent2D.target_position)

func _on_nav_timer_timeout():
	make_path()
