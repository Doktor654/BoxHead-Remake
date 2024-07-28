extends CharacterBody2D


const max_speed = 150.0
const accel = 1500
const friction = 600
@export var weapon : int = 1
@export var hp : int = 100
@export var max_hp : int = 100
@export var input = Vector2.ZERO
@export var dir = 0
@export var syncPos = Vector2(0, 0)
@onready var kamera : Camera2D = $Camera2D
@export var curr_weapon : Weapon
@export var namn : String
@export var in_shop : bool = false

@onready var multiSyncer : MultiplayerSynchronizer = $MultiplayerSynchronizer



func _ready():
	$CanvasLayer/ShopUi.hide()
	if Global.mode == 0:
		$Name.hide()
	Global.player = self
	if Global.mode == 1:
		$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
		
		if !is_multiplayer_authority():
			kamera.make_current()
		$Name.text = str(namn)
		
func _process(delta):
	$HealthBar.value = hp
	if hp <= 0:
		die()
		


func _physics_process(delta):
	if Global.mode == 1:
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			player_movement(delta)
			syncPos = global_position
			if get_global_mouse_position().x < position.x:
				dir = 1
			else:
				dir = 0
				
			if dir == 1:
				$WeaponManager.scale.y = -1
			elif dir == 0:
				$WeaponManager.scale.y = 1
				
		else:
			global_position = global_position.lerp(syncPos, .5)
	elif Global.mode == 0:
		player_movement(delta)
		
		if get_global_mouse_position().x < position.x:
			dir = 1
		else:
			dir = 0
			
		if dir == 1:
			$WeaponManager.scale.x = -1
			$Sprite2D.scale.x = -1
		elif dir == 0:
			$WeaponManager.scale.x = 1
			$Sprite2D.scale.x = 1
			

func get_input():
	input.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	input.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	return input.normalized()
	

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("walk_test")
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)

	move_and_slide()

func hit(dmg):
	hp -= dmg
	

func die():
	get_tree().quit()

func heal(hpplus):
	hp += hpplus
	if hp > max_hp:
		hp = max_hp
