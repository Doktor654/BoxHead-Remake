extends Zombie

var explo = preload("res://scener/Random shit/explosion2.tscn")

#var closest_player = null
#var closest_player_distance = 0.0

@rpc("any_peer")
func _ready():
	$AnimationPlayer.play("come_up")

@rpc("any_peer")
func _physics_process(delta):
	if Global.mode == 0:
		if player_chase:
			#position += (Global.player.position - position) /speed
			position += position.direction_to(Global.player.position) * speed * delta
			$AnimationPlayer.play("walk")
			
			if(Global.player.position.x - position.x) < 0:
				scale.x = 1.5
			else:
				scale.x = -1.5
	elif Global.mode == 1:
		var players = get_parent().get_parent().get_node("Players").get_children()
		if players != null:
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
					scale.x = 1.5
				else:
					scale.x = -1.5
	else:
		print("NO PLAYAS HOMIE")
	
func _process(delta):
	if hp <= 0:
		player_chase = false
		die()
	if can_attack:
		$AnimationPlayer.play("attack")
		
		
@rpc("any_peer")
func hit(dmg, pos):
	hp -= dmg
	var b = blood.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	b.rotation = Global.player.position.angle_to_point(position)
	#knockback(pos)
	
func die():
	$AnimationPlayer.play("Die")
	$CollisionShape2D.disabled = true
	$HitArea/CollisionShape2D.disabled = true




func _on_hit_area_area_entered(area):
	if area.is_in_group("Gubbe"):
		player_chase = false
		can_attack = true



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Die":
		ta_bort()
	if anim_name == "attack":
		var e = explo.instantiate()
		e.position = position
		get_parent().get_parent().add_child(e)
		Global.zombies_killed += 1
		queue_free()
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

@rpc("call_local")
func ta_bort():
	if Global.mode == 0:
		Global.zombies_killed += 1
		Global.money += price
		#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
		queue_free()
	elif Global.mode == 1:
		if is_multiplayer_authority():
			Global.zombies_killed += 1
			Global.money += price
			#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
			rpc("sync_ta_bort")
			queue_free()
		else:
			rpc("sync_ta_bort")
	
@rpc("any_peer")
func sync_ta_bort():
	if !is_multiplayer_authority():
		Global.zombies_killed += 1
		Global.money += price
		#print("ZOMBIES DÖDAD, ", Global.zombies_killed, " / ", Global.max_zombies)
		queue_free()
