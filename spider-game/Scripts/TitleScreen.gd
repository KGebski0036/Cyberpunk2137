extends Node2D


func _on_start_button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
	


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
