extends Node2D

@export var dmg = 100
var ljud = preload("res://scener/ljud/Explosion1.tscn")

func _ready():
	set_as_top_level(true)
	$CPUParticles2D.emitting = true
	$AnimationPlayer.play("explode")
	var l = ljud.instantiate()
	add_child(l)
	l.play()



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()


func _on_hit_box_body_entered(body):
	body.hit(dmg, self.position)
