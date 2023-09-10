extends Node2D

@onready var camera = $BossFightCamera

func _ready():
	camera.make_current()

