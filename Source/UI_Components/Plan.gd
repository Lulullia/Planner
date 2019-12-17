extends Control

#############
###SIGNALS###
#############

signal menu_click


###############
###VARIABLES###
###############

###ONREADY###

onready var line_container = get_node("MainCont/Main/scroll/planlines")

###PRELOAD###

var planline = "res://UI_Components/PlanLine.tscn"
var save_path = "" setget set_save_path

###VARIABLES###

var save_data = {
	
	"info": {
		"name": "",
		"desc": "",
		"notes": "",
		"save_path": ""
	},
	
	"planlines": {
		#Here add planlines by code
	}
}


###############
###FUNCTIONS###
###############

#func _ready():
#	_add_planline(false, null)

func _on_menu_pressed():
	emit_signal("menu_click")


###PLANLINE MANAGEMENT###

#Add planline
func _add_planline(dupli, origin = line_container.get_child(line_container.get_child_count())):
	var new_line = load(planline).instance()
	
	if origin:
		line_container.add_child_below_node(origin, new_line)
	else:
		line_container.add_child(new_line)
	
	#Connect signals
	new_line.connect("wanna_move", self, "_move_planline")
	new_line.connect("wanna_add_line", self, "_add_planline")
	new_line.connect("wanna_delete", self, "_del_planline")
	
	if dupli && origin: #Duplicate
		new_line._load(origin._save())
	
	_check_line_id()

#Id assignment
func _check_line_id():
	
	var line_idx = 1
	var down = true
	
	while line_idx <= line_container.get_child_count():
		var li = line_container.get_child(line_idx - 1)
		if line_idx == line_container.get_child_count():
			down = false
		li.set_id(line_idx - 1, down)
		li._save()
		line_idx += 1
	
	_save()

#Move planline
func _move_planline(dir, li):
	if line_container.get_child_count() > 1:
		var id_to = li.id
		
		if dir == 1: #Up
			id_to -= 1
		else: #Down
			id_to += 1
		
		line_container.move_child(li, id_to)
		_check_line_id()

#Delete planline
func _del_planline(li):
	li.queue_free()
	_check_line_id()

#Button Plus
func _on_plus_pressed():
	_add_planline(false, null)


###SAVING&LOADING###

#Load
func _load(data):
	
	save_data = data
	
	##Loading info
	$Panel/cont/name.text = save_data["info"]["name"]
	$Panel/cont/desc.text = save_data["info"]["desc"]
	$Panel/cont/notes.text = save_data["info"]["notes"]
	
	##Loading planlines
	#Load the first line
	_add_planline(false, null)
	line_container.get_child(0)._load(save_data["planlines"][0])
	
	#Load the rest
	var idx = 1 ##TODO : COMPLETE LOAD SYSTEM
	for line in save_data["planlines"].keys():
		
		if line != 0: #Already loaded this one
			#Instanciate a line
			pass


#Save
func _save():
	
	##Saving info
	save_data["info"]["name"] = $Panel/cont/name.text
	save_data["info"]["desc"] = $Panel/cont/desc.text
	save_data["info"]["notes"] = $Panel/cont/notes.text
	
	##Saving planlines
	for line in line_container.get_children():
		save_data["planlines"][line.id] = line._save()
	
	return save_data

func _on_save_pressed():
	$MainCont/infobar/name.text = $Panel/cont/name.text
	_save()


###OPTIONS###

#Appear & disappear
func _on_options_pressed():
	$anim.play("options")

func _on_options2_pressed():
	$anim.play_backwards("options")


#######################
###SETTERS & GETTERS###
#######################

func set_save_path(value):
	save_path = value
	save_data["infos"]["save_path"] = save_path








