extends CharacterBody3D

@onready var anim = $AnimationPlayer2
@onready var animTree = $AnimationTree
@export var lowerbodyStatePath: String = "parameters/LowerBody/playback"
@export var physBone: PhysicalBone3D
@export var isAttacking: bool = false
var isDying = false
var lowerbodyState
func _ready() -> void:
	lowerbodyState = animTree.get(lowerbodyStatePath) as AnimationNodeStateMachinePlayback

var combo = 0
var chasing

func _process(delta: float) -> void:
	if isDying:
		return
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
		if position.distance_to((player as Node3D).global_position) < 0.2:
			chasing = false
			animTree.tree_root.get_node("OneShot").filter_enabled = false
			lowerbodyState.travel("mixamo_idle_(2)")	
		else: 
			chasing = true
			animTree.tree_root.get_node("OneShot").filter_enabled = true
			lowerbodyState.travel("mixamo_running_(1)")	
		
		
	
func _physics_process(delta: float) -> void:
	if isDying:
		return
	if chasing:
		translate(Vector3.BACK * 0.01)
		move_and_slide()
			#var collision = get_slide_collision(0)
			#print(collision)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if isDying: 
		return
	if body.is_in_group("Player") and isAttacking:
		body.getDamage(10)
		
func getDamage(damage: int):
	if isDying: 
		return
	remove_from_group("Enemy")
	animTree["parameters/OneShot 3/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	isDying = true
	await get_tree().create_timer(4).timeout
	queue_free()
