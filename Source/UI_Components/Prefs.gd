extends Control

signal hid


func _ready():
	$anim.current_animation = "pop"
	$anim.stop()
	$anim.seek(0, true)

func _show():
	_initi()
	$anim.play("pop")
	raise()

func _initi():
	pass

func _hide():
	$anim.play_backwards("pop")

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
