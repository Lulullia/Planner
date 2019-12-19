extends Control


func _on_Main_prefs_click():
	$Prefs._show()

func _on_Prefs_hid():
	move_child($Prefs, 0)
