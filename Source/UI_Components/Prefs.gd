extends Control

signal hid


func _ready():
#	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	$ColorRect.visible = false
	$anim.current_animation = "pop"
	$anim.stop()
	$anim.seek(0, true)

func _show():
	$anim.play("pop")
#	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
#	$ColorRect.visible = true
	raise()

func _hide():
	$anim.play_backwards("pop")
#	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	$ColorRect.visible = false

func _on_save_pressed():
	#save code
	#GLOBAL.global_save["preferences"]
	_hide()


func _on_openprefs_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open(OS.get_user_data_dir())


# warning-ignore:unused_argument
func _on_anim_animation_finished(anim_name):
	if $anim.current_animation_position == 0:
		emit_signal("hid")
