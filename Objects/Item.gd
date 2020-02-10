extends Area2D

const DASH = preload("res://Objects/Items/Dash.tscn")
const LIGHT = preload("res://Objects/Items/Light.tscn")
const FAST = preload("res://Objects/Items/Fast.tscn")

onready var create_item = true

func _physics_process(delta):
	if create_item:
		create_item = false
		new_item()

func new_item():
	var item_type = int(stepify(rand_range(0, 1), 1))
	if item_type == 0:
		new_ability()
	else:
		new_passive()
	
	queue_free()

func new_ability():
	var new_item
	var item = int(stepify(rand_range(1, 1), 1))
	if item == 1:
		new_item = DASH.instance()
	
	get_parent().add_child(new_item)
	
	new_item.position = position

func new_passive():
	var new_item
	var item = int(stepify(rand_range(1, 2), 1))
	if item == 1:
		new_item = LIGHT.instance()
	elif item == 2:
		new_item = FAST.instance()
	
	get_parent().add_child(new_item)
	
	new_item.position = position