extends Node2D
var mainArray = ['1','5','9','13','2','6','10','14','3','7','11','15','4','8','12','']
const correct   = ['1','5','9','13','2','6','10','14','3','7','11','15','4','8','12','']
var steps = 0
const SQ_SIZE = 128

var time = 0
var sqPressed = false
var sqPressedName = ''
var touch = false
var cursor_position = Vector2(0,0)
var start = false

func _ready():
	randomize()
	set_process_input(true)
	set_process(true)
	
func _process(delta):
	if start:
		time += delta
		var minutes = int(time / 60)
		var sec = int(time - (minutes * 60))
		get_node("gui/time").set_text(str("%02d" % minutes) + ":" + str("%02d" % sec))
	

func _input(event):
#	if event.is_action_pressed("space"):
#		get_node("/root/global").time = time
#		get_node("/root/global").steps = steps
#		get_node("/root/global").goto_scene("res://scenes/score.tscn")
	if sqPressed and sqPressedName:
		if event.is_action_released("LMB"):
			cut(findSqByName(sqPressedName))
			sqPressed = false
			sqPressedName = ''
			start = true

func findSqByName(name):
	var index = 0
	for b in mainArray:
		if b == name:
			var col = int(index / 4)
			var row = (index - col * 4)
			return(Vector2(col,row))
		index += 1

func cut(sq):
	var empty = findSqByName('')
	if empty.x == sq.x or empty.y == sq.y:
		var d = 1
		var n = sq.y + (sq.x * 4)
		var e = empty.y + (empty.x * 4)
		if e > n:
			d = -d
		if abs(e - n) >= 4:
			d *= 4
		var m = e
		var q
		while(q != n):
			q = m + d
			mainArray[m] = mainArray[q]
			m = q
		mainArray[n] = ''
		updateSQ()
		steps += 1
		get_node("gui/steps").set_text(str(steps))
		if steps > 2:
			if check_victory():
				get_node("/root/global").time = time
				get_node("/root/global").steps = steps
				get_node("/root/global").goto_scene("res://scenes/score.tscn")
		
func shuffle():
	start = false
	steps = 0
	time = 0
	steps = 0	
	var minutes = int(time / 60)
	var sec = int(time - (minutes * 60))
	get_node("gui/time").set_text(str("%02d" % minutes) + ":" + str("%02d" % sec))
	get_node("gui/steps").set_text(str(steps))
	
	var shuffledList = [] 
	var indexList = range(mainArray.size())
	for i in range(mainArray.size()):
		var x = randi()%indexList.size()
		shuffledList.append(mainArray[indexList[x]])
		indexList.remove(x)
	mainArray = shuffledList

func updateSQ():
	var index = 0
	var table = []
	for b in mainArray:
		var col = int(index / 4)
		var row = (index - col * 4)
		var name = "game/s" + mainArray[index]
		get_node(name).set_pos(Vector2(col * (SQ_SIZE) + SQ_SIZE/2, row * (SQ_SIZE) + SQ_SIZE/2))
		index += 1

func _signal_sqClicked(name):
	sqPressedName = name
	sqPressed = true
	start = true

func check_victory():
	var victory = true
	for i in range(mainArray.size()):
		if mainArray[i] != correct[i]:
			victory = false
	return victory

func _on_Shuffle_pressed():
	sqPressed = false
	sqPressedName = ''
	shuffle()
	updateSQ()
