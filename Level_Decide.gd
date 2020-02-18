extends Node2D

func decide_location():
	var file = File.new()
	file.open("res://save", file.READ)
	var data = file.get_var()
	
	var level = data[4]
	var temple = data[5]
	
	if temple and level > 1:
		get_tree().change_scene("res://Levels/Temple.tscn")
	else:
		temple = false
		if level == 1:
			get_tree().change_scene("res://Levels/1.tscn")
		if level == 2:
			get_tree().change_scene("res://Levels/2.tscn")
		if level == 3:
			get_tree().change_scene("res://Levels/3.tscn")
		if level == 4:
			get_tree().change_scene("res://Levels/4.tscn")
		if level == 5:
			get_tree().change_scene("res://Levels/5.tscn")
		if level == 6:
			get_tree().change_scene("res://Levels/6.tscn")