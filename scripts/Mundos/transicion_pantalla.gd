extends ColorRect

signal transicion_completada

func hacer_transicion():
	visible = true
	$AnimationPlayer.play("fade_in")

func hacer_fade_out():
	$AnimationPlayer.play("fade_out")

func _on_fade_in_finished():
	transicion_completada.emit()

func _on_fade_out_finished():
	visible = false
