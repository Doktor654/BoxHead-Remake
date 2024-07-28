extends Control

var WM
var player

var weapon_scenes = [preload("res://scener/Vapen/Draco.tscn"), preload("res://scener/Vapen/Garand.tscn"), preload("res://scener/Vapen/AK74.tscn")]
# Called when the node enters the scene tree for the first time.
func _ready():
	WM = get_parent().get_parent().get_node("WeaponManager")
	player = get_parent().get_parent()
	$Wave.visible = false
	Global.wave_changed.connect(play_change_wave)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.mode == 0:
		if Global.current_weapon != null:
			if !Global.current_weapon.is_in_group("Empty"):
				$Ammo.text = str(Global.current_weapon.ammo, " / ", Global.current_weapon.max_ammo)
			$Wave.text = str("WAVE: ", Global.wave)
			$Money.text = str(Global.money, "$")
	elif Global.mode == 1:
		if player.multiSyncer.get_multiplayer_authority() == multiplayer.get_unique_id():
			if !WM.vapen.is_in_group("Empty"):
				$Ammo.text = str(WM.vapen.ammo, " / ", WM.vapen.max_ammo)
			$Wave.text = str("WAVE: ", Global.wave)
			$Money.text = str(Global.money, "$")
		else: 
			visible = false


func _on_switch_test_pressed():
	if "switch_on" in Global.current_weapon:
		if !Global.current_weapon.switch_on:
			Global.current_weapon.switch_on = true
		elif Global.current_weapon.switch_on:
			Global.current_weapon.switch_on = false


func _on_ak_pressed():
	WM.new_weapon_test(weapon_scenes[2])


func _on_ak_2_pressed():
	WM.new_weapon_test(weapon_scenes[1])


func play_change_wave():
	$Wave/AnimationPlayer.play("New_round")
