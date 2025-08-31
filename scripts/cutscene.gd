extends Node

@onready var anim = $CutscenePlayer

func _init() -> void:
	anim.play("intro_cutscene")
