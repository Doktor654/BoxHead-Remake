extends StaticBody2D

var explo = preload("res://scener/Random shit/explosion.tscn")
@export var hp = 50
var audi = preload("res://scener/ljud/plink.tscn")

var sounds = [preload("res://ljud/barrel_sounds/metal-hit-15-193280.mp3"), preload("res://ljud/barrel_sounds/metal-hit-90-200426.mp3"), preload("res://ljud/barrel_sounds/metal-hit-94-200422.mp3")]

func hit_barrel(dmg):
	randomize()
	var numb = randi_range(0, 2)
	hp -= dmg
	var a = audi.instantiate()
	a.set_stream(sounds[numb])
	add_child(a)
	a.playing = true
	#$AudioStreamPlayer2D.set_stream(sounds[numb])
	#$AudioStreamPlayer2D.playing = true
	if hp <= 0:
		explode()

func explode():
	var e = explo.instantiate()
	e.position = position
	get_tree().get_root().add_child(e)
	queue_free()
