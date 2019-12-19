extends HBoxContainer

#############
###SIGNALS###
#############

signal wanna_move
signal wanna_add_line
signal wanna_delete

###############
###VARIABLES###
###############

###ONREADY###

onready var buttons = get_node("buttons")
onready var sections = [get_node("sections/split1/split1-1/line1"),
 get_node("sections/split1/split1-1/line2"), get_node("sections/split1/split1-2/line1"), get_node("sections/split1/split1-2/line2"), get_node("sections/split2/split2-1/line1"), get_node("sections/split2/split2-1/line2"), get_node("sections/split2/split2-2/line1"), get_node("sections/split2/split2-2/line2")]

###VARIABLES###

var id = 0 setget set_id
var mode = 0 # 0 = normal | 1 = delete section

var info = {
	"id": 0,
	"sections": {
		"0": {
			"visible": true,
			"text": ""
		},
		
		"1": {
			"visible": false,
			"text": ""
		},
		
		"2": {
			"visible": false,
			"text": ""
		},
		
		"3": {
			"visible": false,
			"text": ""
		},
		
		"4": {
			"visible": false,
			"text": ""
		},
		
		"5": {
			"visible": false,
			"text": ""
		},
		
		"6": {
			"visible": false,
			"text": ""
		},
		
		"7": {
			"visible": false,
			"text": ""
		},
		
		"8": {
			"visible": false,
			"text": ""
		}
	},
	"split_offsets": {
		"sections": 0,
		"split1": 0,
		"split1-1": 0,
		"split1-2": 0,
		"split2": 0,
		"split2-1": 0,
		"split2-2": 0
	}
}


###############
###FUNCTIONS###
###############

func _ready():
	
	buttons.modulate = Color(1, 1, 1, 0)
	$buttons/menu.get_popup().mouse_filter = Control.MOUSE_FILTER_PASS
	
	$buttons/menu.get_popup().connect("id_pressed", self, "_on_menu_pressed")
	
	for lineedit in sections:
		lineedit.connect("gui_input", self, "_on_line_got_focus")
		if lineedit != sections[0]:
			lineedit.visible = false
	
	set_meta("id", id)
	_check_visible()

#Loading a save
func _load(save):
	
	info = save
	
	#Restoring id
	set_id(info["id"])
	
	#Restoring sections info
	for section in sections:
		section.visible = info["sections"][str(sections.find(section))]["visible"]
		section.text = info["sections"][str(sections.find(section))]["text"]
	
	#Restoring split_offsets info
	for split in [$"sections/split1/split1-1", $"sections/split1/split1-2", $"sections/split2/split2-1", $"sections/split2/split2-2", $sections, $sections/split1, $sections/split2]:
		split.split_offset = float(info["split_offsets"][split.name])
	
	_check_visible()

func _save():
	
	#Getting id
	info["id"] = id
	
	#Getting sections info
	for section in sections:
		info["sections"][str(sections.find(section))]["visible"] = section.visible
		info["sections"][str(sections.find(section))]["text"] = section.text
	
	#Getting split_offset info
	for split in [$"sections/split1/split1-1", $"sections/split1/split1-2", $"sections/split2/split2-1", $"sections/split2/split2-2", $sections, $sections/split1, $sections/split2]:
		
		info["split_offsets"][split.name] = split.split_offset
	
	return info

#Buttons apparition
func _on_PlanLine_mouse_entered():
	buttons.modulate = Color(1, 1, 1, 1)
func _on_PlanLine_mouse_exited():
	buttons.modulate = Color(1, 1, 1, 0)

#Menu
func _on_menu_about_to_show():
	buttons.modulate = Color(1, 1, 1, 1)
	if mode == 1:
		mode = 0
		GLOBAL._set_mouse("normal")

func _on_menu_pressed(id):
	
	match id:
		0: #Add Section
			#Check if we can add 1 more
			for line in sections:
				if !line.visible: #If at least 1 line isn't visible
					line.visible = true
					_check_visible()
					break
		
		1: #Duplicate
			emit_signal("wanna_add_line", true, self)
		
		2: #Add Line
			emit_signal("wanna_add_line", false, self)
		
		3: #Delete Section
			#Check if there's at least 2 sections
			var vis = 0
			
			for line in sections:
				if line.visible:
					vis += 1
			
			if vis >= 2:
				mode = 1
				GLOBAL._set_mouse("delete")
			
		4: #Delete Line
			emit_signal("wanna_delete", self)


#Visibility
func _check_visible():
	
	for split in [$"sections/split1/split1-1", $"sections/split1/split1-2", $"sections/split2/split2-1", $"sections/split2/split2-2"]:
		
		var vis = false
		for line in split.get_children():
			if line.visible:
				split.visible = true
				split.dragger_visibility = 0
				vis = true
				break
		
		if !vis:
			split.visible = false
			split.dragger_visibility = 1
	
	for split in [$sections/split1, $sections/split2]:
		
		var vis = false
		for subsplit in split.get_children():
			if subsplit.visible:
				split.visible = true
				split.dragger_visibility = 0
				vis = true
				break
		
		if !vis:
			split.visible = false
			split.dragger_visibility = 1

#Moving
func _on_move_up_pressed():
	if mode == 1:
		mode = 0
		GLOBAL._set_mouse("normal")
	emit_signal("wanna_move", 1, self)
func _on_move_down_pressed():
	if mode == 1:
		mode = 0
		GLOBAL._set_mouse("normal")
	emit_signal("wanna_move", -1, self)

#Deleting
func _on_line_got_focus(event): #Delete Section
	var line = get_focus_owner()
	if mode == 1:
#		line.set_mouse_default_cursor_shape = 3
		if event.is_action("left_click"):
			mode = 0
			GLOBAL._set_mouse("normal")
			line.visible = false
			_check_visible()

#######################
###SETTERS & GETTERS###
#######################

func set_id(value, down = true):
	id = value
	if id == 0:
		$buttons/move_up.modulate = Color(1, 1, 1, 0)
		$buttons/move_up.disabled = true
	else:
		$buttons/move_up.modulate = Color(1, 1, 1, 1)
		$buttons/move_up.disabled = false
	
	if !down:
		$buttons/move_down.modulate = Color(1, 1, 1, 0)
		$buttons/move_down.disabled = true
	else:
		$buttons/move_down.modulate = Color(1, 1, 1, 1)
		$buttons/move_down.disabled = false


