extends Weapon

var _ljud : Array = [preload("res://scener/ljud/pistol_skott.tscn"), preload("res://scener/ljud/silenced_pistol_skott.tscn"), preload("res://scener/ljud/empty_skott.tscn"), preload("res://scener/ljud/rack_ljud.tscn")]
var skott_ljud

var empty_shell = preload("res://scener/Test/bullet_test.tscn")

@export var silencer_on : bool = false
@export var extended_mag_on : bool = false
@export var switch_on : bool = false
@export var clocked = true
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()
	$Muzzle.visible = false
	ammo += max_ammo
	$Accessories/Silencer.hide()
	skott_ljud = _ljud[0]

@rpc("any_peer", "call_local")
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
	
	clock()
	
	if silencer_on:
		$Accessories/Silencer.show()
		$Sprite2D/Marker2D.position = Vector2(22, -5)
		skott_ljud = _ljud[1]
		
	elif !silencer_on:
		$Accessories/Silencer.hide()
		$Sprite2D/Marker2D.position = Vector2(12, -5)
		skott_ljud = _ljud[0]
	
	if extended_mag_on:
		$Accessories/ExtenedMag.show()
		max_ammo = 25
	elif !extended_mag_on:
		$Accessories/ExtenedMag.hide()
		max_ammo = 12
	
	if switch_on:
		$Accessories/Switch.show()
		auto = true
	elif !switch_on:
		$Accessories/Switch.hide()
		auto = false

@rpc("call_local")
func clock():
	if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if !clocked:
			$Glock_Anims.play("Empty")
			if Input.is_action_just_pressed("right_click"):
				clocked = true
				$Glock_Anims.play("RESET")
				skott_ljud = _ljud[3]
				var sl = skott_ljud.instantiate()
				add_child(sl)
				sl.playing = true
				rpc("sync_clock", clocked)
	else:
		rpc("sync_clock", clocked)
			

@rpc("any_peer")
func sync_clock(clocked):
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		if !clocked:
			$Glock_Anims.play("Empty")
			if Input.is_action_just_pressed("right_click"):
				clocked = true
				$Glock_Anims.play("RESET")
				skott_ljud = _ljud[3]
				var sl = skott_ljud.instantiate()
				add_child(sl)
				sl.playing = true

@rpc("call_local")
func skjuta():
	if Global.mode == 0:
		if can_shoot and ammo > 0 and clocked:
			shoot($Sprite2D/Marker2D.global_position)
			$Glock_Anims.play("Recoil")
			can_shoot = false
			var es = empty_shell.instantiate()
			es.position = $Bull_spawn.global_position
			get_parent().add_child(es)
		elif ammo <= 0 and clocked:
			clocked = false
			skott_ljud = _ljud[2]
			var sl = skott_ljud.instantiate()
			add_child(sl)
			sl.playing = true
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			if can_shoot and ammo > 0 and clocked:
				shoot(get_global_mouse_position())
				$Glock_Anims.play("Recoil")
				can_shoot = false
				var es = empty_shell.instantiate()
				es.position = $Bull_spawn.global_position
				get_parent().add_child(es)
				rpc("sync_skjuta", get_global_mouse_position())
			elif ammo <= 0 and clocked:
				clocked = false
				skott_ljud = _ljud[2]
				var sl = skott_ljud.instantiate()
				add_child(sl)
				sl.playing = true
		else:
			rpc("sync_skjuta", get_global_mouse_position())
		
	
@rpc("any_peer")
func sync_skjuta(pos):
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		if can_shoot and ammo > 0 and clocked:
			shoot(pos)
			$Glock_Anims.play("Recoil")
			can_shoot = false
			var es = empty_shell.instantiate()
			es.position = $Bull_spawn.global_position
			get_parent().add_child(es)
		elif ammo <= 0 and clocked:
			clocked = false
			skott_ljud = _ljud[2]
			var sl = skott_ljud.instantiate()
			add_child(sl)
			sl.playing = true
	
func shoot(target_pos):
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
	Global.Camera.shake(0.2, 0.5)
	if !silencer_on:
		$AnimationPlayer.play("Muzzle")





func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Reload":
		ammo = max_ammo
		can_shoot = true 

@rpc("call_local")
func reload():
	if Global.mode == 0:
		$AnimationPlayer.play("Reload")
		can_shoot = false
	if Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
				$AnimationPlayer.play("Reload")
				can_shoot = false
				rpc("sync_reload")
		else:
			rpc("sync_reload")
			

@rpc("any_peer")
func sync_reload():
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		$AnimationPlayer.play("Reload")
		can_shoot = false


func _on_glock_anims_animation_finished(anim_name):
	if anim_name == "Recoil":
		can_shoot = true
