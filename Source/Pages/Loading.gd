extends Control

onready var progress_bar = get_node("margin/main/progress/bar")

func update_progress(progress):
	$Tween.interpolate_property(progress_bar, "value", progress_bar.value, progress, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()