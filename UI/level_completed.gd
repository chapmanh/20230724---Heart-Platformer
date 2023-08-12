extends ColorRect

signal retry()
signal next_level()

@onready var next_level_button = %NextLevelButton
@onready var retry_button = %RetryButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_level_button_pressed():
	print("Next Level")
	next_level.emit()


func _on_retry_button_pressed():
	print("retry")
	retry.emit()
