extends Control


func _on_Load_pressed():
	$FileDialog.popup()



func _on_FileDialog_file_selected(path):
	
	GLOBAL.set_last_dir($FileDialog.current_dir)
	var err = GLOBAL._load(1, path)
	
	if err == "err":
		pass
