extends Node
#<>
#############
###SIGNALS###
#############

###############
###VARIABLES###
###############

###ONREADY###

onready var current_scene = get_node("/root/Splash")

###PRELOAD###

###CONSTANTS###

const global_filepath = "user://global.plan"

#Scenes
const startup_scene = "res://Pages/Startup.tscn"
const plan_scene = "res://UI_Components/Plan.tscn"
const main_scene = "res://Pages/TrueMain.tscn"

###ENUMS###

###VARIABLES###

var resolutions = {1:[1440, 810], 2:[1952, 1098], 0:[1088, 612]}

#Files
var current_filepath
var last_dir = ".." setget set_last_dir

#Scene management
var current_plan

#Save data
var global_save = {
	"preferences": {
		"open_last": false,
		"lang": "en",
		"theme": "pink",
		"autosave": false,
		"save_every": [1, "min"],
		"res": 1,
		"last_dir": ".."
	},
	
	"theme-pink": {
		"main": "res://Assets/themes/Pink.tres"
	},
	
	"recent-plans": {
		#Here add recent plans by code
	}
}


###############
###FUNCTIONS###
###############

func _ready():
	
	#Retrieving global save
	_load(0)


###SCENE MANAGEMENT###

#Changing scenes
func goto_scene(new_scene, loading):
	current_scene.queue_free()
	current_scene = load(new_scene).instance()
	get_tree().get_root().call_deferred("add_child", current_scene)
	
	if loading:
		yield(current_scene, "ready")
		_load(1, current_filepath)


###SAVING&LOADING###

#Saving
func _save(what, quitting, data = null):
	
	if what == 0: #Save prefs
		var conf = ConfigFile.new()
		
		for section in global_save.keys():
			for key in global_save[section]:
				conf.set_value(section, key, global_save[section][key])
		
		conf.save(global_filepath)
	
	else: #Save current file
		var conf = ConfigFile.new()
		
		for section in data.keys():
			for key in data[section]:
				conf.set_value(section, key, data[section][key])
		
		conf.save(current_filepath)
	
	#When save is complete
	if quitting:
		get_tree().quit()

#Loading
func _load(what, filepath = ""):
	
	if what == 0: #Load global.plan
		var conf = ConfigFile.new()
		
		var err = conf.load(global_filepath)
		if err == OK:
			for section in conf.get_sections():
				for key in conf.get_section_keys(section):
					global_save[section][key] = conf.get_value(section, key)
			
			_load_prefs()
			
			return OK
		
		else: #File not found, create new
			_save(0, false)
			
			return OK
	
	else: #Load a Plan
		var conf = ConfigFile.new()
		var err = conf.load(filepath)
		
		if err == OK:
			
			#Retrieving data
			var plan_save = {}
			for section in conf.get_sections():
				plan_save[section] = {}
				for key in conf.get_section_keys(section):
					plan_save[section][key] = conf.get_value(section, key)
			
			#Loading the plan
			current_filepath = filepath
			current_plan._load(plan_save)
		
		return err


#Loading prefs
func _load_prefs():
	
	#Updating res
	if global_save["preferences"]["res"] != 1:
		var res = global_save["preferences"]["res"]
		var reso = Vector2(resolutions[res].front(), resolutions[res].back())
		OS.set_window_size(reso)
	
	#Meta
	set_last_dir(global_save["preferences"]["last_dir"])


#Mouse
func _set_mouse(mode):
	match mode:
		0:
			Input.set_custom_mouse_cursor(load("res://Assets/png/mouse/trashcan.png"), Input.CURSOR_CROSS, Vector2(3, 3))
		"normal":
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
		"delete":
			Input.set_default_cursor_shape(Input.CURSOR_CROSS)

#Quit
func _quit(save = false):
	if save:
		#Do the save-check
		if current_plan:
			global_save["recent-plans"][current_plan.save_data["info"]["name"]] = current_filepath
			_save(0, false)
			_save(1, true, current_plan._save())
		
		else:
			get_tree().quit()
	
	else:
		if current_plan:
			global_save["recent-plans"][current_plan.save_data["info"]["name"]] = current_filepath
		
		_save(0, true)
		get_tree().quit()

#Create plan
func _create_plan(data):
	
	current_filepath = data["filepath"]
	
	goto_scene(main_scene, false)
	yield(current_scene, "ready")
	
	var save_data = {"info": {
		"name": "",
		"desc": "",
		"notes": ""},"planlines": {"0":{}}}
	
	save_data["info"]["name"] = data["name"]
	save_data["info"]["desc"] = data["desc"]
	
	current_plan._load(save_data)
	_save(1, false, current_plan._save())


#######################
###SETTERS & GETTERS###
#######################

func set_last_dir(value):
	last_dir = value
	global_save["preferences"]["last_dir"] = last_dir
	_save(0, false)

