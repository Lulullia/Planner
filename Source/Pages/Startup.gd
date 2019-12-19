extends Control


func _on_Load_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	
	GLOBAL.set_last_dir($FileDialog.current_dir)
	GLOBAL.current_filepath = path
	GLOBAL.goto_scene(GLOBAL.main_scene, true)
