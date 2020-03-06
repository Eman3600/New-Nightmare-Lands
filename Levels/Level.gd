extends Node2D

const MENU = preload("res://PauseMenu.tscn")
onready var platform = preload("res://Objects/Platform.tscn")
onready var main_platform = get_node("Platform")

var level = 0
var temple = false

func _ready():
	create_platforms()
	load_data()

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and !$Player.no_death:
		var menu = MENU.instance()
		add_child(menu)

func save_data():
	print("Saved")
	var file = File.new()
	file.open("res://save", file.WRITE_READ)
	file.store_var([$Player.ability_1, $Player.ability_2, $Player.passive_1, $Player.passive_2, level, temple, $Player.max_hp, $Player.hp, $Player.max_mana, $Player.mana])
	file.close()

func load_data():
	var file = File.new()
	file.open("res://save", file.READ)
	var data = file.get_var()
	$Player.ability_1 = data[0]
	$Player.ability_2 = data[1]
	$Player.passive_1 = data[2]
	$Player.passive_2 = data[3]
	level = data[4]
	temple = data[5]
	$Player.max_hp = data[6]
	$Player.hp = data[7]
	$Player.max_mana = data[8]
	$Player.mana = data[9]
	
	file.close()
	
	$Player.reload_icons()

var rng = RandomNumberGenerator.new()

func create_platforms():
	rng.randomize()
	main_platform.size.x = 3
	main_platform.size.y = 3
	main_platform.position = Vector2(rng.randi_range(0, 1000), rng.randi_range(0, 1000))
	for x in range(10):
		rng.randomize()
		var node = platform.instance()
		node.size.x = 3
		node.size.y = 3
		node.position = Vector2(rng.randi_range(0, 1000), rng.randi_range(0, 1000))
		get_tree().get_root().add_child(node)
