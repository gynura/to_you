extends Node2D

@onready var transitions = $Transitions 

func _ready():
	transitions.enter_screen()
