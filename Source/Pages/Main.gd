extends Control

#############
###SIGNALS###
#############

###############
###VARIABLES###
###############

###ONREADY###

###PRELOAD###

###CONSTANTS###

###ENUMS###

###VARIABLES###


###############
###FUNCTIONS###
###############

###MENU###

#Appear & disappear
func _on_Plan_menu_click():
	$anim.play("menu")
func _on_menu2_pressed():
	$anim.play_backwards("menu")

#Save
func _on_save_pressed():
	$Plan._save()

#Preferences
func _on_prefs_mouse_entered():
	$anim.play("prefs")
func _on_prefs_mouse_exited():
	$anim.play_backwards("prefs")


#######################
###SETTERS & GETTERS###
#######################












