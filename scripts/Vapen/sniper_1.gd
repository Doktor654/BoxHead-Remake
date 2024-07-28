extends Weapon

var _ljud : Array = [preload("res://scener/ljud/Sniper1_skott.tscn")]
var skott_ljud

var empty_shell = preload("res://scener/Test/big_bullet_test.tscn")

var player
var is_reloading : bool = false

func _ready():
	player = get_parent().get_parent()
	ammo += max_ammo
	
	

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	if Global.mode == 0:
		look_at(mouse_pos)
	elif Global.mode == 1:
		for playern in Global.Players:
			if playern == player.name.to_int():
				if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
					get_parent().look_at(mouse_pos)
				else:
					pass
					
			
	skott_ljud = _ljud[0]
func skjuta():
	if can_shoot and ammo > 0:
		shoot(get_global_mouse_position())
		$SniperAnims.play("Recoil")
		can_shoot = false
		
func shoot(target_pos):
	var bullet = kulan.instantiate()
	bullet.dmg = dmg
	bullet.position = $Sprite2D/Marker2D.global_position
	bullet.direction = (target_pos - player.position).normalized()
	bullet.look_at(get_global_mouse_position())
	get_parent().add_child(bullet)
	ammo -= 1
	Global.Camera.shake(0.1, 2)
	var sl = skott_ljud.instantiate()
	add_child(sl)
	sl.playing = true


@rpc("call_local")
func reload():
	if Global.mode == 0:
		$SniperAnims.play("Reload")
		can_shoot = false
		is_reloading = true
		var es = empty_shell.instantiate()
		es.position = $Bull_spawn.global_position
		get_parent().add_child(es)
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			$SniperAnims.play("Reload")
			can_shoot = false
			is_reloading = true
			var es = empty_shell.instantiate()
			es.position = $Bull_spawn.global_position
			get_parent().add_child(es)
			rpc("sync_reload")
		else:
			rpc("sync_reload")

@rpc("any_peer")
func sync_reload():
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
			$SniperAnims.play("Reload")
			can_shoot = false
			is_reloading = true
			var es = empty_shell.instantiate()
			es.position = $Bull_spawn.global_position
			get_parent().add_child(es)


func _on_sniper_anims_animation_finished(anim_name):
	if anim_name == "Recoil":
		can_shoot = true
		get_parent().shooting = false
	if anim_name == "Reload":
		ammo = max_ammo
		can_shoot = true 
		is_reloading = false
		
