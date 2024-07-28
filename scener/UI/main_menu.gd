extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_solo_pressed():
	get_tree().change_scene_to_file("res://scener/Värld/world.tscn")
	Global.mode = 0
	print(Global.mode)

func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://scener/UI/multi_player_lobby.tscn")
	Global.mode = 1
	print("Mode: ", Global.mode)

func _on_quit_pressed():
	get_tree().quit()
