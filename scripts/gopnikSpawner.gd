extends Node3D

@export var gopnik: PackedScene
var timer: Timer
func _ready() -> void:
	return
	timer = get_node("timer")
	timer.start()
func _physics_process(delta: float) -> void:
	return
	if timer.is_stopped():
		var gop = gopnik.instantiate()
		add_child(gop)
		timer.start()
		
	
