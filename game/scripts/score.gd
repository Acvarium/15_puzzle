extends Node2D
var time = 0
var steps = 0

func _ready():
	time = get_node("/root/global").time
	steps = get_node("/root/global").steps
	get_node("bg/steps").set_text(str(steps))

	var minutes = int(time / 60)
	var sec = int(time - (minutes * 60))
	get_node("bg/time").set_text(str("%02d" % minutes) + ":" + str("%02d" % sec))

func _on_back_pressed():
	get_node("/root/global").goto_scene("res://scenes/main.tscn")
