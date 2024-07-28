extends Node2D

var weapons: Array = []
var vapen
@export var shooting: bool
var player

var weapon_scenes = [preload("res://scener/Vapen/Draco.tscn"), preload("res://scener/Vapen/Garand.tscn"), preload("res://scener/Vapen/AK74.tscn")]


func _ready():
	player = get_parent()
	weapons = get_children()
	if Global.mode == 0:
		Global.current_weapon = weapons[1]
		print(Global.current_weapon)
		for weapon in weapons:
			weapon.hide()
		Global.current_weapon.show()
	elif Global.mode == 1:
		vapen = weapons[1]
		for weapon in weapons:
			weapon.hide()
		vapen.show()
		
@rpc("call_local")
func switch_weapon(weapon):
	if Global.mode == 0:
		if weapon == Global.current_weapon:
			return
		Global.current_weapon.hide()
		weapon.show()
		Global.current_weapon = weapon
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			if weapon == vapen:
				return
			vapen.hide()
			weapon.show()
			vapen = weapon
			rpc("sync_switch_weapon", weapon.get_path())
		else:
			rpc("sync_switch_weapon", weapon.get_path())
			
@rpc("any_peer")
func sync_switch_weapon(weapon_path):
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		var weapon = get_node(weapon_path)  # Convert ID back to object
		if weapon == vapen:
			return
		vapen.hide()
		weapon.show()
		vapen = weapon


func shoot_weapon():
	if Global.mode == 0:
		if !Global.current_weapon.is_in_group("Empty"):
			Global.current_weapon.skjuta()
	elif Global.mode == 1:
		if !vapen.is_in_group("Empty"):
			vapen.skjuta()



func _process(delta):
	if Global.mode == 0:
		if Input.is_action_just_pressed("Click"):
			shoot_weapon()
		if Input.is_action_pressed("Click"):
			if !Global.current_weapon.is_in_group("Empty"):
				if Global.current_weapon.auto:
					shoot_weapon()
		if Input.is_action_just_pressed("weapon1"):
			switch_weapon(weapons[0])
		if Input.is_action_just_pressed("weapon2"):
			switch_weapon(weapons[1])
		if Input.is_action_just_pressed("R"):
			if !Global.current_weapon.is_in_group("Empty"):
				Global.current_weapon.reload()
			
	elif Global.mode == 1:
		if Input.is_action_just_pressed("Click"):
			shoot_weapon()
		if Input.is_action_pressed("Click"):
			if !vapen.is_in_group("Empty"):
				if vapen.auto:
					shoot_weapon()
		if Input.is_action_just_pressed("R"):
			if !vapen.is_in_group("Empty"):
				vapen.reload()
		if Input.is_action_just_pressed("weapon1"):
			switch_weapon(weapons[0])
		if Input.is_action_just_pressed("weapon2"):
			switch_weapon(weapons[1])
			
			
#Main Weapon
@rpc("call_local")
func new_weapon_test(target):
	if Global.mode == 0:
		weapons[0].queue_free()
		remove_child(weapons[0])
		print("BYTER VAPEN")
		node_instance_weapon1(target)
		weapons = get_children()
		if Global.current_weapon == weapons[1]:
			Global.current_weapon.hide()
			weapons[0].show()
			Global.current_weapon = weapons[0]
		else:
			Global.current_weapon = weapons[0]
			
			
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			weapons[0].queue_free()
			remove_child(weapons[0])
			print("BYTER VAPEN")
			node_instance_weapon1(target)
			weapons = get_children()
			if vapen == weapons[1]:
				vapen.hide()
				weapons[0].show()
				vapen = weapons[0]
				rpc("sync_new_weapon_test", target.get_path())
			else:
				vapen = weapons[0]
				rpc("sync_new_weapon_test", target.get_path())
		else:
			rpc("sync_new_weapon_test", target.get_path())
			
@rpc("any_peer")
func sync_new_weapon_test(target_path):
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		var target = load(target_path)
		weapons[0].queue_free()
		remove_child(weapons[0])
		print("BYTER VAPEN")
		node_instance_weapon1(target)
		weapons = get_children()
		if vapen == weapons[1]:
			vapen.hide()
			weapons[0].show()
			vapen = weapons[0]
		else:
			vapen = weapons[0]

func node_instance_weapon1(node):
	var noden = node.instantiate()
	#node.position = self.position
	add_child(noden)
	move_child(noden, 0)


#Secondary Weapon
@rpc("call_local")
func new_weapon_test2(target):
	if Global.mode == 0:
		weapons[1].queue_free()
		remove_child(weapons[1])
		print("BYTER VAPEN")
		node_instance_weapon2(target)
		weapons = get_children()
		if Global.current_weapon == weapons[0]:
			Global.current_weapon.hide()
			weapons[1].show()
			Global.current_weapon = weapons[1]
		else:
			Global.current_weapon = weapons[1]
			
			
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			weapons[1].queue_free()
			remove_child(weapons[1])
			print("BYTER VAPEN")
			node_instance_weapon2(target)
			weapons = get_children()
			if vapen == weapons[0]:
				vapen.hide()
				weapons[1].show()
				vapen = weapons[1]
				rpc("sync_new_weapon_test2", target.get_path())
			else:
				vapen = weapons[0]
				rpc("sync_new_weapon_test2", target.get_path())
		else:
			rpc("sync_new_weapon_test2", target.get_path())
			
@rpc("any_peer")
func sync_new_weapon_test2(target_path):
	if player.multiSyncer.get_multiplayer_authority() != multiplayer.get_unique_id():
		var target = load(target_path)
		weapons[1].queue_free()
		remove_child(weapons[1])
		print("BYTER VAPEN")
		node_instance_weapon2(target)
		weapons = get_children()
		if vapen == weapons[0]:
			vapen.hide()
			weapons[1].show()
			vapen = weapons[1]
		else:
			vapen = weapons[1]


func node_instance_weapon2(node):
	var noden = node.instantiate()
	#node.position = self.position
	add_child(noden)
	move_child(noden, 1)
