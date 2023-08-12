extends Area2D

@onready var heart_sound = $HeartSound

func _on_area_entered(area):
	var heart_count = get_tree().get_nodes_in_group("hearts").size()
	SoundManager.heart_beat.play()
	if heart_count == 1:
		Events.level_completed.emit()
	queue_free()
