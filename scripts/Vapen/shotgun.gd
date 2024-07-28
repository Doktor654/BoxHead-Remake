extends StaticBody2D

class_name Weapon

@export var kulan : PackedScene
@export var bull_amount : int = 3
@export var ammo : int
@export var max_ammo: int = 6
@export var dmg : int 
@export var auto: bool = false
var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready():
	ammo += max_ammo


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
			
	
func skjuta():
	if can_shoot and ammo > 0:
		shoot($Sprite2D/Marker2D.global_position)
		$AnimationPlayer.play("Recoil")
		can_shoot = false
		ammo -= 1
		print("shot")
		
func shoot(target_pos):
	var bullet = kulan.instantiate()
	bullet.position = $Sprite2D/Marker2D.global_position
	bullet.direction = (target_pos - Global.player.position).normalized()
	get_tree().current_scene.add_child(bullet)
	
	var bullet2 = kulan.instantiate()
	bullet2.position = $Sprite2D/Marker2D.global_position
	bullet2.direction = (Vector2(target_pos.x, target_pos.y - 5) - Global.player.position).normalized()
	get_tree().current_scene.add_child(bullet2)
	
	var bullet3 = kulan.instantiate()
	bullet3.position = $Sprite2D/Marker2D.global_position
	bullet3.direction = (Vector2(target_pos.x, target_pos.y + 5) - Global.player.position).normalized()
	get_tree().current_scene.add_child(bullet3)
	
	#print(bullet.position)
	#print(bullet2.position)
	#print(bullet3.position)

func reload():
	ammo = max_ammo


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Recoil":
		can_shoot = true
