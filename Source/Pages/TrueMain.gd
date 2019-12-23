extends Control


func _on_Main_prefs_click():
	$Prefs._show()

func _on_Prefs_hid():
	move_child($Prefs, 1)

func _on_Main_new_click():
	$New._show()

func _on_New_hid():
	move_child($New, 1)
