extends Control

signal found_server(ip, port, roomInfo)
signal update_server(ip, port, roomInfo)
signal server_removed
signal Join(ip)

var broadcastTimer : Timer

var RoomInfo = {"name" : "name", "PlayerCount" : 0}
var broadcaster : PacketPeerUDP
var listener : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastAdress : String = "192.168.1.255"

@export var serverInfo : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	setUp()

func setUp():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	
	if ok == OK:
		print("Bound to Listen Port " + str(listenPort) + "Succesful!")
		$BoundToListenPort.text ="Bound to listen Port: True"
	else:
		print("failed to bind to Listen port!")
		$BoundToListenPort.text ="Bound to listen Port: False"
	

func setUpBroadCast(name):
	RoomInfo.name = name
	RoomInfo.playerCount = Global.Players.size()
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAdress, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to Broadcast Port " + str(broadcastPort) + "Succesful!")
	else:
		print("failed to bind to broadcast port!")
		
	broadcastTimer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if listener.get_available_packet_count() > 0:
		var serverip = listener.get_packet_ip()
		var serverport = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		
		print("ServerIp: ", str(serverip) + "Serverport: ", str(serverport)  + "RoomInfo: ",  str(roomInfo))
		
		for i in $Panel/VBoxContainer.get_children():
			if i.name == roomInfo.name:
				update_server.emit(serverip, serverport, roomInfo)
				i.get_node("Ip").text = serverip
				i.get_node("PlayerCount").text = str(roomInfo.playerCount)
				return

		var currentInfo = serverInfo.instantiate()
		currentInfo.name = roomInfo.name
		currentInfo.get_node("Name").text = roomInfo.name
		currentInfo.get_node("Ip").text = serverip
		currentInfo.get_node("PlayerCount").text = str(roomInfo.playerCount)
		$Panel/VBoxContainer.add_child(currentInfo)
		currentInfo.joinGame.connect(joinByIp)
		found_server.emit(serverip, serverport, roomInfo)
		
func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	RoomInfo.playerCount = Global.Players.size()
	
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
	
func cleanUp():
	listener.close()
	
	broadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

	

func _exit_tree():
	cleanUp()

func joinByIp(ip):
	Join.emit(ip)
