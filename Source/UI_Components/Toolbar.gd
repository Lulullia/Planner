extends HBoxContainer

###############
###VARIABLES###
###############

var following = false
var drag_start_pos = Vector2()


###############
###FUNCTIONS###
###############

# warning-ignore:unused_argument
func _process(delta):
	if following:
		OS.set_window_position(OS.window_position + 
							get_global_mouse_position() - drag_start_pos)

#Window dragging
func _on_ToolBar_gui_input(event):
	if event is InputEventMouseButton && event.get_button_index() == 1:
		following = !following
		drag_start_pos = get_local_mouse_position()

#Minimize
func _on_Minimize_pressed():
	OS.set_window_minimized(true)

#Fullscreen
func _on_Fullscreen_toggled(button_pressed):
	if button_pressed:
		OS.window_fullscreen = true
		$Fullscreen.icon = load("res://Assets/png/minimize.png")
	if !button_pressed:
		$Fullscreen.icon = load("res://Assets/png/fullscreen.png")
		OS.window_fullscreen = false

#Close
func _on_Close_pressed():
	GLOBAL._quit(true)

func _on_QuitYes_pressed():
	GLOBAL._quit()
func _on_QuitNo_pressed():
	$Close/QuitConfirm.hide()

func _on_SaveNo_pressed():
	GLOBAL._quit()
func _on_SaveYes_pressed():
	GLOBAL._save(1, true)
func _on_SaveCancel_pressed():
	$Close/SaveConfirm.hide()

#Name
func set_doc_title(value):
	$DocTitle.text = value
