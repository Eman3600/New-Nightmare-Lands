extends Node2D

func decide_location():
	var file = File.new()
	file.open("res://save", file.READ)
	var data = file.get_var()
	
	var level = data[4]
	var temple = data[5]
	
	if temple:
		get_tree().change_scene("res://Levels/Temple.tscn")
	else:
		if level == 1:
			get_tree().change_scene("res://Levels/1.tscn")