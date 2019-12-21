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
	$file.current_dir = GLOBAL.last_dir
	$Panel/cont/desc.text = ""
	$Panel/cont/name.text = ""
	$Panel/cont/path/line.text = ""

func _hide():
	$anim.play_backwards("pop")

func _on_browse_pressed():
	$file.popup()

func _on_file_file_selected(path):
	$Panel/cont/path/line.text = str(path)
	GLOBAL.last_dir = $file.current_dir

func _on_save_pressed():
	var data = {}
	
	data["name"] = $Panel/cont/name.text
	data["desc"] = $Panel/cont/desc.text
	data["filepath"] = $Panel/cont/path/line.text
	GLOBAL._create_plan(data)
	
	_hide()

# warning-ignore:unused_argument
func _on_anim_animation_finished(anim_name):
	if $anim.current_animation_position == 0:
		emit_signal("hid")

func _on_cancel_pressed():
	_hide()
