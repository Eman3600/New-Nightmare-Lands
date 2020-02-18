extends Node2D

var selected_item = false
const LOAD = preload("res://Level_Decide.tscn")

func _ready():
	load_icons()

# Reload Icons

func load_icons():
	var file = File.new()
	file.open("res://save", file.READ)
	var data = file.get_var()
	var ability_1 = data[0]
	var ability_2 = data[1]
	var passive_1 = data[2]
	var passive_2 = data[3]
	
	if ability_1 == 1:
		$Options/Ability1/AnimatedSprite.play("Dash")
	if ability_2 == 1:
		$Options/Ability2/AnimatedSprite.play("Dash")
	
	if ability_1 == 2:
		$Options/Ability1/AnimatedSprite.play("DownBurst")
	if ability_2 == 2:
		$Options/Ability2/AnimatedSprite.play("DownBurst")
	
	if passive_1 == 1:
		$Options/Passive1/AnimatedSprite.play("Light")
	if passive_2 == 1:
		$Options/Passive2/AnimatedSprite.play("Light")
	
	if passive_1 == 2:
		$Options/Passive1/AnimatedSprite.play("Fast")
	if passive_2 == 2:
		$Options/Passive2/AnimatedSprite.play("Fast")

# Return to Game

func _on_RESTART_pressed():
	if selected_item:
		var load_data = LOAD.instance()
		add_child(load_data)
		load_data.decide_location()


func _on_QUIT_pressed():
	if selected_item:
		get_tree().change_scene("res://TitleScreen.tscn")

# Select Ability to Keep

func _on_Ability1_pressed():
	if !selected_item:
		var file = File.new()
		file.open("res://save", file.READ)
		var data = file.get_var()
		file.close()
		file.open("res://save", file.WRITE_READ)
		file.store_var([data[0], 0, 0, 0, 1, false, 20, 20, 20, 20])
		file.close()
		selected_item = true
		$RESTART.show()
		$QUIT.show()
		$Options.hide()
		$Instructions.hide()


func _on_Ability2_pressed():
	if !selected_item:
		var file = File.new()
		file.open("res://save", file.READ)
		var data = file.get_var()
		file.close()
		file.open("res://save", file.WRITE_READ)
		file.store_var([0, data[1], 0, 0, 1, false, 20, 20, 20, 20])
		file.close()
		selected_item = true
		$RESTART.show()
		$QUIT.show()
		$Options.hide()
		$Instructions.hide()


func _on_Passive1_pressed():
	if !selected_item:
		var file = File.new()
		file.open("res://save", file.READ)
		var data = file.get_var()
		file.close()
		file.open("res://save", file.WRITE_READ)
		file.store_var([0, 0, data[2], 0, 1, false, 20, 20, 20, 20])
		file.close()
		selected_item = true
		$RESTART.show()
		$QUIT.show()
		$Options.hide()
		$Instructions.hide()


func _on_Passive2_pressed():
	if !selected_item:
		var file = File.new()
		file.open("res://save", file.READ)
		var data = file.get_var()
		file.close()
		file.open("res://save", file.WRITE_READ)
		file.store_var([0, 0, 0, data[3], 1, false, 20, 20, 20, 20])
		file.close()
		selected_item = true
		$RESTART.show()
		$QUIT.show()
		$Options.hide()
		$Instructions.hide()
