extends KinematicBody2D
export var num = 1
signal sqClicked(name)

func _ready():
	self.connect("sqClicked",get_node("/root/main"),"_signal_sqClicked")
	get_node("num").set_text(str(num))
	if num == 0:
		get_node("sq").hide()
		get_node("shadow").hide()
		get_node("num").hide()

func _on_sq_button_down():
	emit_signal("sqClicked", str(num))
