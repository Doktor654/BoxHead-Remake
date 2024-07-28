extends Node2D

@export var dmg = 50

func _ready():
	set_as_top_level(true)
	$CPUParticles2D.emitting = true
	$AnimationPlayer.play("explode")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()


func _on_hit_box_area_entered(area):
	if area.is_in_group("Gubbe"):
		area.get_parent().hit(dmg)
