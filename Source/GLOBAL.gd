extends Node
#<>
#############
###SIGNALS###
#############

###############
###VARIABLES###
###############

###ONREADY###

###PRELOAD###

###CONSTANTS###
const global_filepath = "user://global.plan"

###ENUMS###

###VARIABLES###
var resolutions = {1:[1440, 810], 2:[1952, 1098], 0:[1088, 612]}
var current_filepath

#Save data
var global_save = {
	"preferences": {
		"res": 1}
}

var plan_save = {}


###############
###FUNCTIONS###
###############

func _ready():
	
	#Retrieving save
	var file = File.new()
	if file.file_exists("user://prefs.plan"):
		var conf = ConfigFile.new()
		conf.load("user://prefs.plan")
		
	
	###Updating res
	if global_save["preferences"]["res"] != 1:
		var res = global_save["preferences"]["res"]
		var reso = Vector2(resolutions[res].front(), resolutions[res].back())
		OS.set_window_size(reso)

#Saving
func _save(what, quitting):
	
	#Save global_save
	if what == 0:
		var conf = ConfigFile.new()
		
		for section in global_save.keys():
			for key in global_save[section]:
				conf.set_value(section, key, global_save[section][key])
		
		conf.save(global_filepath)
	
	print("saved")
	
	#When save is complete
	if quitting:
		_quit()

#Quit
func _quit(toolbar = null):
	if toolbar:
		#Do the save-check etc
		get_tree().quit()
	else:
		get_tree().quit()

#######################
###SETTERS & GETTERS###
#######################


