extends Weapon

var _ljud : Array = [preload("res://scener/ljud/Shotgun_skott.tscn")]
var skott_ljud

var empty_shell = preload("res://scener/Test/shotgun_bullet_test.tscn")

var player
var is_reloading : bool = false

const MAX_SPREAD = deg_to_rad(10)
const BULLET_COUNT = 5

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
		if ammo == 2:
			shoot(get_global_mouse_position())
			$ShotgunAnim.play("Recoil")
			can_shoot = false
		elif ammo == 1:
			shoot(get_global_mouse_position())
			$ShotgunAnim.play("Recoil2")
			can_shoot = false
		
func shoot(target_pos):
	if ammo == 2:
		var direction = (target_pos - player.position).normalized()
		for i in range(BULLET_COUNT):
			var bullet = kulan.instantiate()
			bullet.dmg = dmg
			var angle_offset = lerp(-MAX_SPREAD, MAX_SPREAD, float(i)/BULLET_COUNT)
			#bullet.rotation = angle_offset
			bullet.direction = direction.rotated(angle_offset)
			bullet.position = $Sprite2D/Marker1.global_position
			get_parent().add_sibling(bullet)
			
			
			print(i)
			
		ammo -= 1
		Global.Camera.shake(0.1, 2)
		var sl = skott_ljud.instantiate()
		add_child(sl)
		sl.playing = true
		var es = empty_shell.instantiate()
		es.position = $Bull_spawn.global_position
		get_parent().add_child(es)
			
	elif ammo == 1:
		var direction = (target_pos - player.position).normalized()
		for i in range(BULLET_COUNT):
			var bullet = kulan.instantiate()
			bullet.dmg = dmg
			var angle_offset = lerp(-MAX_SPREAD, MAX_SPREAD, float(i)/BULLET_COUNT)
			#bullet.rotation = angle_offset
			bullet.direction = direction.rotated(angle_offset)
			bullet.position = $Sprite2D/Marker2.global_position
			get_parent().add_sibling(bullet)
			
			print(i)
			
		ammo -= 1
		Global.Camera.shake(0.1, 2)
		var sl = skott_ljud.instantiate()
		add_child(sl)
		sl.playing = true
		var es = empty_shell.instantiate()
		es.position = $Bull_spawn.global_position
		get_parent().add_child(es)

func _on_shotgun_anim_animation_finished(anim_name):
	if anim_name == "Recoil":
		can_shoot = true
		get_parent().shooting = false
		
	if anim_name == "Recoil2":
		can_shoot = true
		get_parent().shooting = false
