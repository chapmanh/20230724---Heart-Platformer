extends Area2D

func _on_area_entered(area):
	queue_free()
	var heart_count = get_tree().get_nodes_in_group("hearts").size()
	if heart_count == 1:
		Events.level_completed.emit()
		print("Level completed!")
