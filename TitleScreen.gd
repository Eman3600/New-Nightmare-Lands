extends Node2D

const LOAD = preload("res://Level_Decide.tscn")
var esc_count = 0

func _ready():
	var meta = File.new()
	meta.open("res://meta", meta.READ)
	var meta_data = meta.get_var()
	meta.close()
	if meta_data == 0:
		start_tutorial()

func _physics_process(delta):
	var rngesus = randi()
	if Input.is_action_just_pressed("ui_cancel"):
		esc_count += 1
		if esc_count == 10:
			var meta = File.new()
			meta.open("res://meta", meta.WRITE_READ)
			meta.store_var(0)
			meta.close()
			get_tree().quit()



func _on_Start_pressed():
	var load_data = LOAD.instance()
	add_child(load_data)
	
	load_data.decide_location()

func start_tutorial():
	_on_Delete_pressed()
	var meta = File.new()
	meta.open("res://meta", meta.WRITE_READ)
	meta.store_var(1)
	get_tree().change_scene("res://Levels/Tutorial.tscn")

# Deletes Data

func _on_Delete_pressed():
	var ability_1 = 0
	var ability_2 = 0
	var passive_1 = 0
	var passive_2 = 0
	var level = 1
	var temple = false
	var max_hp = 20
	var hp = max_hp
	var max_mana = 20
	var mana = max_mana
	
	var file = File.new()
	file.open("res://save", file.WRITE_READ)
	file.store_var([ability_1, ability_2, passive_1, passive_2, level, temple, max_hp, hp, max_mana, mana])
	file.close()


func _on_Quit_pressed():
	get_tree().quit()
