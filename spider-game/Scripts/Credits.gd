extends Node2D

export onready var file = 'res://Credits.txt'

func _ready():
	$CreditsText/Timer.start()
	load_credits()

func load_credits():
	var f = File.new()
	f.open(file, File.READ)
	var credits_text = ""
	while !f.eof_reached():
		credits_text += f.get_line() + "\n"
	f.close()
	$CreditsText.set_text(credits_text)
	return

func _on_Timer_timeout():
	$CreditsText.rect_global_position.y -= 1

