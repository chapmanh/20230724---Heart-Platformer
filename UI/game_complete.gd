extends CenterContainer

signal retry()

@export var main_menu :PackedScene

@onready var retry_button = %RetryButton
@onready var main_menu_button = %MainMenuButton
@onready var quit_button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_main_menu_button_pressed():
	await LevelTransition.fade_out()
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
	LevelTransition.fade_in()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_retry_button_pressed():
	retry.emit()
