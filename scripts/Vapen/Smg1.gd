extends Weapon


var _ljud : Array = [preload("res://scener/ljud/pistol_skott.tscn"), preload("res://scener/ljud/silenced_pistol_skott.tscn")]
var skott_ljud

@export var silencer_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo += max_ammo
	print(ammo)
	$Accessories/Silencer.hide()
	$Sprite2D/Marker2D.position = Vector2(11, -3)
	skott_ljud = _ljud[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	
	if silencer_on:
		$Accessories/Silencer.show()
		$Sprite2D/Marker2D.position = Vector2(20, -4)
		skott_ljud = _ljud[1]
	elif !silencer_on:
		$Accessories/Silencer.hide()
		$Sprite2D/Marker2D.position = Vector2(11, -3)
		skott_ljud = _ljud[0]
	
	
func skjuta():
	if can_shoot and ammo > 0:
		shoot($Sprite2D/Marker2D.global_position)
		$AnimationPlayer.play("Recoil")
		can_shoot = false
		print("shot")
	
func shoot(target_pos):
	var bullet = kulan.instantiate()
	bullet.position = $Sprite2D/Marker2D.global_position
	bullet.direction = (target_pos - Global.player.position).normalized()
	bullet.look_at(get_global_mouse_position())
	get_tree().current_scene.add_child(bullet)
	ammo -= 1
	var sl = skott_ljud.instantiate()
	add_child(sl)
	sl.playing = true




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Recoil":
		can_shoot = true
	if anim_name == "Reload":
		ammo = max_ammo
		can_shoot = true 

func reload():
	$AnimationPlayer.play("Reload")
	can_shoot = false
