extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var countdown_animation = %CountdownAnimation

func _ready():
	LevelTransition.fade_in()
	Events.level_completed.connect(_on_level_completed)
	get_tree().paused = true
	#countdown_animation.play("countdown")
	await countdown_animation.go
	get_tree().paused = false
	
func _on_level_completed():
	level_completed.show()
	if next_level:
		get_tree().paused = true
		await LevelTransition.fade_out()
		get_tree().change_scene_to_packed(next_level)

func _on_countdown_animation_go():
	pass
