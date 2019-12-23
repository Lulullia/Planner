extends VBoxContainer

var recent_line = "res://UI_Components/RecentLine.tscn"

export var small = false

func _ready():
	var recent = GLOBAL.global_save["preferences"]["recent-plans"]
	for li in recent:
		_add_line(li[0], li[1])
	if small:
		for li in get_children():
			li.set_small()

func _add_line(lname, filepath):
	var li = load(recent_line).instance()
	
	add_child(li, true)
	
	li._initi(lname, filepath)

func _initi():
	var childs = get_children()
	if childs.size() > 0:
		for child in childs:
			remove_child(child)
			child.queue_free()
	_ready()

