extends VBoxContainer


var myster_box_opening = preload("res://scener/UI/weapon_box_system.tscn")


#@export (Array, Texture) var blue_items
#@export (Array, Texture) var purple_items
#@export (Array, Texture) var red_items
#@export (Array, Texture) var special_items
@export var blue_items : Array[Texture]
@export var purple_items : Array[Texture]
@export var red_items : Array[Texture]
@export var gold_items : Array[Texture]


var item_list = {}


func _ready():
	item_list = {
	"blue_items": blue_items,
	"purple_items": purple_items,
	"red_items": red_items,
	"gold_items" : gold_items
	#"special_items": special_items
	}



func _on_button_pressed():
	var opening_scene = myster_box_opening.instantiate()
	opening_scene.item_list = item_list
	get_tree().get_root().add_child(opening_scene)
