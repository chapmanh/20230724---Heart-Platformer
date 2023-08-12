extends Node2D

@export var next_level: PackedScene

var t_0: float = 0.0 # timestamp for start of level
var t_level: float = 0.0 # differene between current time and t_0

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var game_complete = $CanvasLayer/GameComplete
@onready var countdown_animation = %CountdownAnimation
@onready var level_time_label = %LevelTimeLabel

func _ready():
	LevelTransition.fade_in()
	Events.level_completed.connect(_on_level_completed)
	get_tree().paused = true
	#countdown_animation.play("countdown")
	#await countdown_animation.go
	
func _process(delta):
	t_level = Time.get_ticks_msec() - t_0
	level_time_label.text = "%.2f" % (t_level/1000.0)

func go_to_next_level():
	if next_level:
		await LevelTransition.fade_out()
		get_tree().change_scene_to_packed(next_level)

func retry():
	await LevelTransition.fade_out()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)
	

func _on_level_completed():
	get_tree().paused = true
	if next_level:
		level_completed.show()
		level_completed.retry_button.grab_focus()
	else:
		game_complete.show()
		game_complete.main_menu_button.grab_focus()
	
func _on_countdown_animation_go():
	get_tree().paused = false
	t_0 = Time.get_ticks_msec()
	print(t_0)

func _on_level_completed_next_level():
	go_to_next_level()


func _on_level_completed_retry():
	retry()
