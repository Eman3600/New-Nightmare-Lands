extends Node

const MENU = preload("res://ExitMenu.tscn")

onready var root = get_parent()
onready var player = root.get_node("Player")
onready var camera = player.get_node("Camera2D")

func leave():
	player.leaving = true
	
	root.temple = true
	root.level += 1
	root.save_data()
	
	var menu = MENU.instance()
	get_parent().add_child(menu)

func _ready():
	var CAMERA_X = 2
	var CAMERA_Y = 2
	
	camera.limit_bottom = 720 * CAMERA_Y
	camera.limit_right = 1280 * CAMERA_X
