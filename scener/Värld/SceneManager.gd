extends Node2D

@export var PlayerScene : PackedScene

func _ready():
	#MultiPlayer
	if Global.mode == 1:
		var index : int = 0
		for i in Global.Players:
			var currentPlayer = PlayerScene.instantiate()
			currentPlayer.name = str(Global.Players[i].id)
			currentPlayer.namn = str(Global.Players[i].name)
			$Players.add_child(currentPlayer)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position
			index += 1
			print(Global.Players)
	#solo
	elif Global.mode == 0:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.position = $SpawnLocations/"0".position
		add_child(currentPlayer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
