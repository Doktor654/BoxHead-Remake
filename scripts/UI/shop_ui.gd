extends Control

var WM
var player
var weapon_scenes = [preload("res://scener/Vapen/Draco.tscn"), preload("res://scener/Vapen/Garand.tscn"), preload("res://scener/Vapen/AK74.tscn"), preload("res://scener/Vapen/P90.tscn"), preload("res://scener/Vapen/Mp5.tscn"), preload("res://scener/Vapen/TommyGun.tscn"), preload("res://scener/Vapen/sniper_1.tscn")]
var weapon_prices = [500, 50, 250, 325, 225, 1, 100]
var secondary_weapon_scenes = [preload("res://scener/Vapen/Pistol.tscn"), preload("res://scener/Vapen/Makarov.tscn"), preload("res://scener/Vapen/Small_revolver.tscn")]
var secondary_weapon_prices = [150, 250, 500]

var weapon_texture = [load("res://textures/Vapen/AR3.png"), load("res://textures/Vapen/Garand.png"), load("res://textures/Vapen/AK-74.png"), load("res://textures/Vapen/p90n.png"), load("res://textures/Vapen/mp5.png"), load("res://textures/Vapen/tommy_gun.png"), load("res://textures/Vapen/Sniper1.png")]
var secondary_weapon_texture = [load("res://textures/Vapen/makarov.png"), load("res://textures/Vapen/Glock.png"), load("res://textures/Vapen/small_revo.png")]

var page : int


func _ready():
	page = 0
	visible = false
	WM = get_parent().get_parent().get_node("WeaponManager")
	player = get_parent().get_parent()
	


func _process(delta):
	if Global.mode == 0:
		if Input.is_action_just_pressed("x"):
			if !visible:
				visible = true
				if Global.current_weapon.name != "Empty":
					Global.current_weapon.can_shoot = false
			else:
				visible = false
				if Global.current_weapon.name != "Empty":
					Global.current_weapon.can_shoot = true
	
	elif Global.mode == 1:
		if Input.is_action_just_pressed("x"):
			if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
				if !visible:
					visible = true
					if WM.vapen.name != "Empty":
						WM.vapen.can_shoot = false
				else:
					visible = false
					if WM.vapen.name != "Empty":
						WM.vapen.can_shoot = true
			else:
				visible = false

	if page == 1 or page == 0:
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt3/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt4/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt6/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt7/Vapen/AnimationPlayer.play("hover")

	if page == 0:
	#priser
		$TextureRect/ScrollContainer/GridContainer/butt1/Price.text = str("$", weapon_prices[1])
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen.texture = weapon_texture[1]
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen.hframes = 1
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen/AnimationPlayer.play("hover")
		
		$TextureRect/ScrollContainer/GridContainer/butt2/Price.text = str("$", weapon_prices[4])
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen.texture = weapon_texture[4]
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen.hframes = 3
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen.vframes = 2
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen/AnimationPlayer.play("hover")
		
		$TextureRect/ScrollContainer/GridContainer/butt3/Price.text = str("$", weapon_prices[0])
		$TextureRect/ScrollContainer/GridContainer/butt3/Vapen.texture = weapon_texture[0]
		$TextureRect/ScrollContainer/GridContainer/butt3/Vapen/AnimationPlayer.play("hover")
		
		$TextureRect/ScrollContainer/GridContainer/butt4/Price.text = str("$", weapon_prices[2])
		$TextureRect/ScrollContainer/GridContainer/butt4/Vapen.texture = weapon_texture[2]
		$TextureRect/ScrollContainer/GridContainer/butt4/Vapen/AnimationPlayer.play("hover")
		
		$TextureRect/ScrollContainer/GridContainer/butt5/Price.text = str("$", weapon_prices[5])
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen.texture = weapon_texture[5]
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen/AnimationPlayer.play("hover")
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen.hframes = 1
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen.vframes = 1
		
		$TextureRect/ScrollContainer/GridContainer/butt6/Price.text = str("$", weapon_prices[3])
		$TextureRect/ScrollContainer/GridContainer/butt6/Vapen.texture = weapon_texture[3]
		$TextureRect/ScrollContainer/GridContainer/butt6/Vapen/AnimationPlayer.play("hover")
		
		$TextureRect/ScrollContainer/GridContainer/butt7/Price.text = str("$", weapon_prices[6])
		$TextureRect/ScrollContainer/GridContainer/butt7/Vapen.texture = weapon_texture[6]
		$TextureRect/ScrollContainer/GridContainer/butt7/Vapen.hframes = 1
		$TextureRect/ScrollContainer/GridContainer/butt7/Vapen.vframes = 1
		#print("WM: ", WM)
		#print ("PLAYEER: ", player)
	elif page == 1:
		$TextureRect/ScrollContainer/GridContainer/butt1/Price.text = str("$", secondary_weapon_prices[2])
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen.texture = secondary_weapon_texture[2]
		$TextureRect/ScrollContainer/GridContainer/butt1/Vapen.hframes = 2
		
		$TextureRect/ScrollContainer/GridContainer/butt2/Price.text = str("$", secondary_weapon_prices[0])
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen.texture = secondary_weapon_texture[1]
		$TextureRect/ScrollContainer/GridContainer/butt2/Vapen.vframes = 1
		
		$TextureRect/ScrollContainer/GridContainer/butt3/Price.text = str("SOON")
		$TextureRect/ScrollContainer/GridContainer/butt3/Vapen.texture = null
		
		$TextureRect/ScrollContainer/GridContainer/butt4/Price.text = str("SOON")
		$TextureRect/ScrollContainer/GridContainer/butt4/Vapen.texture = null
		
		$TextureRect/ScrollContainer/GridContainer/butt5/Price.text = str("SOON")
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen.texture = secondary_weapon_texture[0]
		$TextureRect/ScrollContainer/GridContainer/butt5/Vapen.hframes = 3
		
		$TextureRect/ScrollContainer/GridContainer/butt6/Price.text = str("SOON")
		$TextureRect/ScrollContainer/GridContainer/butt6/Vapen.texture = null

func _on_button_1_pressed():
	if page == 0:
		if Global.money >= weapon_prices[1]:
			WM.new_weapon_test(weapon_scenes[1])
			Global.money -= weapon_prices[1]
	elif page == 1:
		if Global.money >= secondary_weapon_prices[2]:
			WM.new_weapon_test2(secondary_weapon_scenes[2])
			Global.money -= secondary_weapon_prices[2]
			
func _on_button_3_pressed():
	if page == 0:
		if Global.money >= weapon_prices[0]:
			WM.new_weapon_test(weapon_scenes[0])
			Global.money -= weapon_prices[0]


func _on_button_4_pressed():
	if page == 0:
		if Global.money >= weapon_prices[2]:
			WM.new_weapon_test(weapon_scenes[2])
			Global.money -= weapon_prices[2]


func _on_button_2_pressed():
	if page == 0:
		if Global.money >= weapon_prices[4]:
			WM.new_weapon_test(weapon_scenes[4])
			Global.money -= weapon_prices[4]
	elif page == 1:
		if Global.money >= secondary_weapon_prices[0]:
			WM.new_weapon_test2(secondary_weapon_scenes[0])
			Global.money -= secondary_weapon_prices[0]


func _on_button_6_pressed():
	if page == 0:
		if Global.money >= weapon_prices[3]:
			WM.new_weapon_test(weapon_scenes[3])
			Global.money -= weapon_prices[3]
	


func _on_page_pressed():
	if page != 0:
		page = 0
		$TextureRect/Sprite2D.frame = 0
		
	


func _on_page_2_pressed():
	if page != 1:
		page = 1
		$TextureRect/Sprite2D.frame = 1


func _on_page_3_pressed():
	if page != 2:
		page = 2
		$TextureRect/Sprite2D.frame = 2


func _on_page_4_pressed():
	if page != 3:
		page = 3
		$TextureRect/Sprite2D.frame = 3


func _on_button_5_pressed():
	if page == 0:
		if Global.money >= weapon_prices[5]:
			WM.new_weapon_test(weapon_scenes[5])
			Global.money -= weapon_prices[5]


func _on_button_7_pressed():
	if page == 0:
		if Global.money >= weapon_prices[6]:
			WM.new_weapon_test(weapon_scenes[6])
			Global.money -= weapon_prices[6]
