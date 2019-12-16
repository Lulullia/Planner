extends HBoxContainer

#############
###SIGNALS###
#############

signal move_up
signal move_down
signal menu_action(line, action)

###############
###VARIABLES###
###############

###ONREADY###

onready var buttons = get_node("buttons")
onready var sections = [get_node("sections/split1/split1-1/line1"),
 get_node("sections/split1/split1-1/line2"), get_node("sections/split1/split1-2/line1"), get_node("sections/split1/split1-2/line2"), get_node("sections/split2/split2-1/line1"), get_node("sections/split2/split2-1/line2"), get_node("sections/split2/split2-2/line1"), get_node("sections/split2/split2-2/line2")]

###CONSTANTS###

###ENUMS###

###VARIABLES###

var id = 0

var info = {
	"id": 0,
	"sections": {
		0: {
			"visible": true,
			"text": ""
		},
		
		1: {
			"visible": false,
			"text": ""
		},
		
		2: {
			"visible": false,
			"text": ""
		},
		
		3: {
			"visible": false,
			"text": ""
		},
		
		4: {
			"visible": false,
			"text": ""
		},
		
		5: {
			"visible": false,
			"text": ""
		},
		
		6: {
			"visible": false,
			"text": ""
		},
		
		7: {
			"visible": false,
			"text": ""
		},
		
		8: {
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
		if lineedit != sections[0]:
			lineedit.visible = false

#Loading a save
func _load(save):
	info = save
	
	#Restoring id
	id = info["id"]
	
	#Restoring sections info
	for section in sections:
		section.visible = info["sections"][sections.find(section)]["visible"]
		section.text = info["sections"][sections.find(section)]["text"]
	
	#Restoring split_offsets info
	for split in $sections.get_children():
		split.split_offset = info["split_offsets"][split.name] 

func _save():
	
	#Getting id
	info["id"] = id
	
	#Getting sections info
	for section in sections:
		info["sections"][sections.find(section)]["visible"] = section.visible
		info["sections"][sections.find(section)]["text"] = section.text
	
	#Getting split_offset info
	for split in $sections.get_children():
		info["split_offsets"][split.name] = split.split_offset
	
	print(info)
	
	return info

#Buttons apparition
func _on_PlanLine_mouse_entered():
	buttons.modulate = Color(1, 1, 1, 1)
func _on_PlanLine_mouse_exited():
	buttons.modulate = Color(1, 1, 1, 0)

#Menu
func _on_menu_about_to_show():
	buttons.modulate = Color(1, 1, 1, 1)

func _on_menu_pressed(id):
	pass

#######################
###SETTERS & GETTERS###
#######################



func _on_move_up_pressed():
	print("press")
	_save()


