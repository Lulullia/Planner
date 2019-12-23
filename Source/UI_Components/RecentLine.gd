extends HBoxContainer

var path = ""

func _initi(lname, lpath):
	$name.text = lname
	$path.text = lpath
	path = lpath

func _on_RecentPlans_gui_input(event):
	if event.is_action_pressed("left_click"):
		GLOBAL._load(1, path)

func set_small():
	$sep2.visible = false
	$path.visible = false