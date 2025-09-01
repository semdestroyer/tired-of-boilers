extends CharacterBody3D

@onready var anim = $AnimationPlayer2
@onready var animTree = $AnimationTree
@export var lowerbodyStatePath: String = "parameters/LowerBody/playback"
var lowerbodyState
func _ready() -> void:
	lowerbodyState = animTree.get(lowerbodyStatePath) as AnimationNodeStateMachinePlayback

var combo = 0
var chasing

func _process(delta: float) -> void:
	for player in get_tree().get_nodes_in_group("Player"):
		look_at((player as Node3D).position,Vector3.UP, true)
		if position.distance_to((player as Node3D).global_position) < 0.5:
			if !animTree.get("parameters/OneShot/active"):
				if combo == 1:
					animTree["parameters/OneShot 2/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
					combo = 0
				else:
					animTree["parameters/OneShot 2/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
					combo += 1
				animTree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
		if position.distance_to((player as Node3D).global_position) < 0.3:
			chasing = false
			animTree.tree_root.get_node("OneShot").filter_enabled = false
			lowerbodyState.travel("mixamo_idle_(2)")	
		else: 
			chasing = true
			animTree.tree_root.get_node("OneShot").filter_enabled = true
			lowerbodyState.travel("mixamo_running_(1)")	
		
		
	
func _physics_process(delta: float) -> void:
	if chasing:
		translate(Vector3.BACK * 0.01)
		if move_and_slide():
			var collision = get_slide_collision(0)
			print(collision)
