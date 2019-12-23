extends Control


func _on_Load_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	
	GLOBAL.set_last_dir($FileDialog.current_dir)
	GLOBAL.current_filepath = path
	GLOBAL.goto_scene(GLOBAL.main_scene, true)


func _on_New_pressed():
	$New._show()

func _on_New_hid():
	move_child($New, 1)

func _on_prefs_mouse_entered():
	$anim.play("prefs")
func _on_prefs_mouse_exited():
	$anim.play_backwards("prefs")
func _on_prefs_pressed():
	$Prefs._show()
func _on_Prefs_hid():
	move_child($Prefs, 1)
