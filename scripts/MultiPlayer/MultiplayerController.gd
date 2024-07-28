extends Control

@export var Address = "127.0.0.1"
@export var port = 1911
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.disconnect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

	$ServerBrowser.Join.connect(JoinByIp)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#gets called on the server and clients
func PlayerConnected(id):
	print("Player Connected ", id)
#gets called on the server and clients
func PlayerDisconnected(id):
	print("Player Disconnected ", id)
	
#Called only from clients
func connected_to_server():
	print("Connected to server")
	sendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
#Called only from clients
func connection_failed():
	print("Connected failed")
	
	
@rpc("any_peer")
func sendPlayerInformation(name, id):
	if !Global.Players.has(id):
		Global.Players[id] = {
			"name" : name,
			"id" : id,
			
		}
	if multiplayer.is_server():
		for i in Global.Players:
			sendPlayerInformation.rpc(Global.Players[i].name, i)
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://scener/Värld/multiplayer_test_scen.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("Cannot host:", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players!")

func _on_host_button_down():
	hostGame()
	sendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	$ServerBrowser.setUpBroadCast($LineEdit.text + "'s Server")
	
func _on_join_button_down():
	#peer = ENetMultiplayerPeer.new()
	#peer.create_client(Address, port)
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	#multiplayer.set_multiplayer_peer(peer)
	JoinByIp(Address)

func JoinByIp(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_button_down():
	StartGame.rpc()


func _on_test_butt_pressed():
	Global.Players[Global.Players.size() + 1] = {
			"name" : "test",
			"id" : 1
		}
