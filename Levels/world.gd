extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(_on_level_completed)
	LevelTransition.fade_in()
	get_tree().paused = false
	
func _on_level_completed():
	level_completed.show()
	if next_level:
		get_tree().paused = true
		await LevelTransition.fade_out()
		get_tree().change_scene_to_packed(next_level)
#		get_tree().paused = false
		
		
		
