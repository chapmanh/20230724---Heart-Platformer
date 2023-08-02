extends AnimationPlayer

signal go

func _on_go():
	emit_signal("go")
	
