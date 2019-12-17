extends Node
#<>
#############
###SIGNALS###
#############

###############
###VARIABLES###
###############

###ONREADY###

onready var thread = Thread.new()
onready var current_scene = get_node("/root/Splash")

###PRELOAD###

###CONSTANTS###

const global_filepath = "user://global.plan"

#Scenes
const loading_scene = "res://Pages/Loading.tscn"
const startup_scene = "res://Pages/Startup.tscn"
const plan_scene = "res://UI_Components/Plan.tscn"

###ENUMS###

###VARIABLES###

var resolutions = {1:[1440, 810], 2:[1952, 1098], 0:[1088, 612]}

#Files
var current_filepath
var last_dir = ".." setget set_last_dir

#Scene management
var current_name
var current_plan

var loaded_scene

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
	
	"recent-plans": [
		#Here add recent plans by code
	]
}


###############
###FUNCTIONS###
###############

func _ready():
	
	#Retrieving global save
	_load(0)
	
	###Updating res
	if global_save["preferences"]["res"] != 1:
		var res = global_save["preferences"]["res"]
		var reso = Vector2(resolutions[res].front(), resolutions[res].back())
		OS.set_window_size(reso)


###SCENE MANAGEMENT###

#Changing scenes
func goto_scene(new_scene, loading, load_scene = ""):
	current_scene.queue_free()
	current_scene = new_scene
	get_tree().get_root().call_deferred("add_child", current_scene)
	
	if loading:
		thread.start(self, "prep_scene", ResourceLoader.load_interactive(load_scene))

#Loading
func prep_scene(interactive_ldr):
	
	while true:
		var err = interactive_ldr.poll()
		if err == ERR_FILE_EOF:
			call_deferred("_on_load_level_done")
			return interactive_ldr.get_resource()
		elif err == OK:
			update_progress(interactive_ldr)

func update_progress(loader):
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	current_scene.update_progress(progress)

func _on_load_level_done():
	loaded_scene = thread.wait_to_finish()
	var scene = loaded_scene.instance()
	goto_scene(scene, false)

###SAVING&LOADING###

#Saving
func _save(what, quitting, data = null):
	
	if what == 0: #Save prefs
		var conf = ConfigFile.new()
		
		for section in global_save.keys():
			for key in global_save[section]:
				conf.set_value(section, key, global_save[section][key])
		
		conf.save(global_filepath)
		print("Preferences Saved")
	
	else: #Save current file
		var conf = ConfigFile.new()
		
		for section in data.keys():
			for key in data[section]:
				conf.set_value(section, key, data[section][key])
		
		conf.save(current_filepath)
		print("Plan Saved")
	
	#When save is complete
	if quitting:
		_quit()

#Loading
func _load(what, filepath = ""):
	
	if what == 0: #Load global.plan
		var conf = ConfigFile.new()
		
		var err = conf.load(global_filepath)
		if err == OK:
			print("-- Loading prefs.plan")
			for section in conf.get_sections():
				for key in conf.get_section_keys(section):
					global_save[section][key] = conf.get_value(section, key)
		else:
			match err:
				ERR_FILE_NOT_FOUND:
					print("File not found.")
					_save(0, false)
				ERR_FILE_ALREADY_IN_USE:
					print("Couldn't open. File already in use.")
				_:
					print("Couldn't open. File is corrupted.")
			
			print("-- Creating prefs.plan")
			_save(0, false)
	
	else: #Load a Plan
		var conf = ConfigFile.new()
		var err = conf.load(filepath)
		
		if err == OK:
			print("-- Loading " + filepath)
			
			#Retrieving data
			var plan_save = {}
			for section in conf.get_sections():
				for key in conf.get_section_keys(section):
					plan_save[section][key] = conf.get_value(section, key)
			
			#Creating plan instance
			current_plan = load(plan_scene).instance()
			current_plan._load(plan_save)
			
			goto_scene(current_plan, false)
		
		else:
			match err:
				ERR_FILE_NOT_FOUND:
					print("File not found.")
					_save(0, false)
				ERR_FILE_ALREADY_IN_USE:
					print("Couldn't open. File already in use.")
				_:
					print("Couldn't open. File is corrupted.")
			
			return "err"

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
		#Do the save-check etc
		if current_name:
			global_save["recent-plans"].push_front([current_name, current_filepath])
			_save(0, true)
		else:
			get_tree().quit()
	else:
		global_save["recent-plans"].push_front([current_name, current_filepath])
		_save(0, true)

#######################
###SETTERS & GETTERS###
#######################

func set_last_dir(value):
	last_dir = value
	global_save["preferences"]["last_dir"] = last_dir

