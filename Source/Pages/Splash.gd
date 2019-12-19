extends Control

# warning-ignore:unused_argument
func splash_end(anim):
	GLOBAL.goto_scene(GLOBAL.startup_scene, false)


func _on_tex_pressed():
	$anim.seek(1.3, true)
	$anim.stop()
	yield(get_tree().create_timer(0.5), "timeout")
	splash_end(0)
