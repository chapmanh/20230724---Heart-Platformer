extends MarginContainer

@onready var button_start = %ButtonStart
@onready var button_quit = %ButtonQuit

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	SoundManager.background_music.play()
	button_start.grab_focus()

func _on_button_start_pressed():
	await LevelTransition.fade_out()
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_button_quit_pressed():
	get_tree().quit()
