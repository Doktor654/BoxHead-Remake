extends Weapon


var _ljud : Array = [preload("res://scener/ljud/AK74_skott.tscn"), preload("res://scener/ljud/silenced_pistol_skott.tscn"), preload("res://scener/ljud/empty_skott.tscn")]
var skott_ljud

var empty_shell = preload("res://scener/Test/big_bullet_test.tscn")
var mag = preload("res://scener/Vapen/MAG/AK-74_mag.tscn")
var player
@export var is_reloading : bool = false
@export var sync_pos = Vector2(0, 0)

@export var silencer_on : bool = false
func _ready():
	player = get_parent().get_parent()
	ammo += max_ammo
	$Accessories/Silencer.hide()
	$Sprite2D/Marker2D.position = Vector2(11, -3)
	skott_ljud = _ljud[0]

@rpc("any_peer", "call_local")
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	#if Global.mode == 1:
		#if !is_multiplayer_authority():
			#look_at(get_global_mouse_position())
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

		
	
@rpc("call_local")
func skjuta():
	if Global.mode == 0:
		if can_shoot and ammo > 0:
			if Global.mode == 0 or (Global.mode == 1):
				shoot(get_global_mouse_position())
				$AnimationPlayer.play("Recoil")
				get_parent().shooting = true
				can_shoot = false
				var es = empty_shell.instantiate()
				es.position = $Bull_spawn.global_position
				get_parent().add_child(es)
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			if can_shoot and ammo > 0:
					shoot(get_global_mouse_position())
					#print("Playern: ", playern, "Player: ", player)
					$AnimationPlayer.play("Recoil")
					get_parent().shooting = true
					can_shoot = false
					var es = empty_shell.instantiate()
					es.position = $Bull_spawn.global_position
					get_parent().add_child(es)
					rpc("sync_shoot", get_global_mouse_position())
			if ammo <= 0 and !is_reloading:
				$AnimationPlayer.play("empty")
		else:
			rpc("sync_shoot", get_global_mouse_position())

@rpc("any_peer")
func sync_shoot(position):
	# Denna metod kommer att kallas av andra spelare för att synkronisera skjutningen
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		shoot(position)
		$AnimationPlayer.play("Recoil")
		get_parent().shooting = true
		can_shoot = false

		# Skapa och positionera en tom hylsa
		var es = empty_shell.instantiate()
		es.position = $Bull_spawn.global_position
		get_parent().add_child(es)

		if ammo <= 0 and !is_reloading:
			$AnimationPlayer.play("empty")

	

func shoot(target_pos):
	if Global.mode == 0:
		var bullet = kulan.instantiate()
		bullet.dmg = dmg
		bullet.position = $Sprite2D/Marker2D.global_position
		bullet.direction = (target_pos - player.position).normalized()
		bullet.look_at(get_global_mouse_position())
		get_parent().add_child(bullet)
		ammo -= 1
		var sl = skott_ljud.instantiate()
		add_child(sl)
		sl.playing = true
		Global.Camera.shake(0.1, 0.7)
		print("Skjuter")
	
	elif Global.mode == 1:
		var bullet = kulan.instantiate()
		bullet.dmg = dmg
		bullet.position = $Sprite2D/Marker2D.global_position
		bullet.direction = (target_pos - player.position).normalized()
		bullet.look_at(get_global_mouse_position())
		get_parent().add_child(bullet)
		ammo -= 1
		var sl = skott_ljud.instantiate()
		add_child(sl)
		sl.playing = true
		Global.Camera.shake(0.1, 0.7)
		print("Skjuter")




func _on_animation_player_animation_finished(anim_name):
	if Global.mode == 0:
		if anim_name == "Recoil":
			can_shoot = true
			get_parent().shooting = false
		if anim_name == "reload":
			$Mag.position = Vector2(6.345, 4.6)
			ammo = max_ammo
			can_shoot = true 
			is_reloading = false
			
		if anim_name == "empty":
			skott_ljud = _ljud[2]
			var sl = skott_ljud.instantiate()
			add_child(sl)
			sl.playing = true
	if Global.mode == 1:
		if anim_name == "Recoil":
			can_shoot = true
			get_parent().shooting = false
		if anim_name == "reload":
			$Mag.position = Vector2(6.345, 4.6)
			ammo = max_ammo
			can_shoot = true 
			is_reloading = false
			
		if anim_name == "empty":
			skott_ljud = _ljud[2]
			var sl = skott_ljud.instantiate()
			add_child(sl)
			sl.playing = true
		
		
@rpc("call_local")
func reload():
	if Global.mode == 0:
		var m = mag.instantiate()
		m.position = $Mag.position
		$Mag.add_child(m)
		$AKAnims.play("reload")
		can_shoot = false
		is_reloading = true
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			var m = mag.instantiate()
			m.position = $Mag.position
			$Mag.add_child(m)
			$AKAnims.play("reload")
			can_shoot = false
			is_reloading = true
			rpc("sync_reload")
		else:
			rpc("sync_reload")

@rpc("any_peer")
func sync_reload():
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
			var m = mag.instantiate()
			m.position = $Mag.position
			$Mag.add_child(m)
			$AKAnims.play("reload")
			can_shoot = false
			is_reloading = true
	
func remove_mag():
	if Global.mode == 0:
		if $Mag.get_child_count() > 0:
			$Mag.get_child(0).reparent($Mag.get_parent().get_parent().get_parent().get_parent())
	
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			if $Mag.get_child_count() > 0:
				$Mag.get_child(0).reparent($Mag.get_parent().get_parent().get_parent().get_parent())
		else:
			pass


func _on_ak_anims_animation_finished(anim_name):
	if Global.mode == 0:
		if anim_name == "reload":
			$Mag.position = Vector2(6.345, 4.6)
			ammo = max_ammo
			can_shoot = true 
			is_reloading = false
	elif Global.mode == 1:
		if anim_name == "reload":
			$Mag.position = Vector2(6.345, 4.6)
			ammo = max_ammo
			can_shoot = true 
			is_reloading = false
		
