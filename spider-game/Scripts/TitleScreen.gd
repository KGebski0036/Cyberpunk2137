extends Node2D


func _on_start_button_pressed():
	if get_tree().change_scene("res://Scenes/Main.tscn"):
		print("dupa")
	
