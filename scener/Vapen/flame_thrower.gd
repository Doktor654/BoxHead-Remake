extends Weapon

var player
var skjuter : bool = false
var speed = 350
var hit : bool = false

func _ready():
	player = get_parent().get_parent()
	$CPUParticles2D.emitting = false
	ammo = max_ammo


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
					
					
	if Input.is_action_just_pressed("R"):
		reload()

	if skjuter and ammo > 0:
		$FireArea.monitoring = true
		$FireArea.position += position.direction_to($Sprite2D/Marker2D.position) * speed * delta
		if $FireArea.position >= $Sprite2D/Marker2D.position:
			$FireArea.position = Vector2(0, -4)
			ammo -= 1
		
	elif ammo <= 0:
		$CPUParticles2D.emitting = false
		$FireArea/CollisionShape2D.disabled = true
		skjuter = false
		$Flames.stop()
		
func skjuta():
	if !skjuter and ammo > 0:
		skjuter = true
		$CPUParticles2D.emitting = true
		$FireArea/CollisionShape2D.disabled = false
		$Flames.play()
	elif skjuter:
		skjuter = false
		$CPUParticles2D.emitting = false
		$FireArea.position = Vector2(0, -4)
		$FireArea/CollisionShape2D.disabled = true
		$Flames.stop()
		
		
func reload():
	ammo = max_ammo
		


func _on_fire_area_body_entered(body):
	if body.has_method("hit"):
		body.hit(dmg, self.position)
		print("hit with ", dmg)
		
	if body.has_method("hit_barrel"):
		body.hit_barrel(dmg)


func _on_fire_area_body_exited(body):
	hit = false
