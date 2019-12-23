extends Control

#############
###SIGNALS###
#############

signal prefs_click
signal new_click

###############
###VARIABLES###
###############

var mode = 0 # 0 : Save | 1 = Load
onready var file = get_node("file")

###############
###FUNCTIONS###
###############

func _ready():
	GLOBAL.current_plan = $Plan

###MENU###

#Appear & disappear
func _on_Plan_menu_click():
	$anim.play("menu")
func _on_menu2_pressed():
	$anim.play_backwards("menu")

#Save
func _on_save_pressed():
	GLOBAL._save(1, false, $Plan._save())
	_on_menu2_pressed()
func _on_saveas_pressed():
	mode = 0
	_file_init()
	file.popup()

func _on_file_selected(path):
	
	if mode == 0: #Save
		GLOBAL.current_filepath = path
		GLOBAL.set_last_dir(file.current_dir)
		GLOBAL._save(1, false, $Plan._save())
		_on_menu2_pressed()
	
	else: #Load
		GLOBAL.set_last_dir(file.current_dir)
		GLOBAL.current_filepath = path
		var err = GLOBAL._load(1, path)
		
		if err != OK: #Problem
			$ErrorLoad/cont/code.text = str(err)
			$ErrorLoad.popup()
		_on_menu2_pressed()

func _file_init():
	
	file.current_dir = GLOBAL.last_dir
	
	if mode == 0:
		file.mode = FileDialog.MODE_SAVE_FILE
	else:
		file.mode = FileDialog.MODE_OPEN_FILE

#Load
func _on_load_pressed():
	mode = 1
	_file_init()
	file.popup_centered()


#Preferences
func _on_prefs_mouse_entered():
	$anim.play("prefs")
func _on_prefs_mouse_exited():
	$anim.play_backwards("prefs")
func _on_prefs_pressed():
	emit_signal("prefs_click")

#New
func _on_new_pressed():
	emit_signal("new_click")

#######################
###SETTERS & GETTERS###
#######################