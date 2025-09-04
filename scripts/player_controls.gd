extends CharacterBody3D

@onready var anim = $AnimationPlayer3
@onready var animTree = $AnimationTree

@export var upperbodyStatePath: String = "parameters/UpperBody/playback"
@export var lowerbodyStatePath: String = "parameters/LowerBody/playback"
@export var progressBar: ProgressBar
@export var gopnikCounterText: RichTextLabel
@export var isAttacking: bool = false
var gopnikCounter = 0

var isDead = false
var upperbodyState
var lowerbodyState

var direction = Vector3.ZERO
var combo = 0
var template: String
func _ready() -> void:
	upperbodyState = animTree.get(upperbodyStatePath) as AnimationNodeStateMachinePlayback
	lowerbodyState = animTree.get(lowerbodyStatePath) as AnimationNodeStateMachinePlayback
func _process(delta: float) -> void:
	if isDead:
		return
	if Input.is_action_just_pressed("move_left"):
		animTree.tree_root.get_node("OneShot").filter_enabled = true
		lowerbodyState.travel("mixamo_running_(1)")
		direction.x = 1
	if Input.is_action_just_pressed("move_right"):
		animTree.tree_root.get_node("OneShot").filter_enabled = true
		lowerbodyState.travel("mixamo_running_(1)")
		direction.x = -1
	if Input.is_action_just_pressed("move_forward"):
		animTree.tree_root.get_node("OneShot").filter_enabled = true
		lowerbodyState.travel("mixamo_running_(1)")
		direction.z = 1
	if Input.is_action_just_pressed("move_backward"):
		animTree.tree_root.get_node("OneShot").filter_enabled = true
		lowerbodyState.travel("mixamo_running_(1)")
		direction.z = -1
	if Input.is_action_just_pressed("attack"):
		if combo == 1:
			animTree["parameters/OneShot 2/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
			combo = 0
		else:
			animTree["parameters/OneShot 2/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			combo += 1
		animTree["parameters/Blend2/blend_amount"] = 1.0
		animTree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	if Input.is_action_just_released("move_left"):
		animTree.tree_root.get_node("OneShot").filter_enabled = false
		lowerbodyState.travel("mixamo_idle_(2)")
		direction.x = 0
	if Input.is_action_just_released("move_right"):
		animTree.tree_root.get_node("OneShot").filter_enabled = false
		lowerbodyState.travel("mixamo_idle_(2)")
		direction.x = 0
	if Input.is_action_just_released("move_forward"):
		animTree.tree_root.get_node("OneShot").filter_enabled = false
		lowerbodyState.travel("mixamo_idle_(2)")
		direction.z = 0
	if Input.is_action_just_released("move_backward"):
		animTree.tree_root.get_node("OneShot").filter_enabled = false
		lowerbodyState.travel("mixamo_idle_(2)")
		direction.z = 0
	#if Input.is_action_just_released("move_left") and Input.is_action_just_released("move_right") and Input.is_action_just_released("move_forward") and Input.is_action_just_released("move_backward"):

func _physics_process(delta: float) -> void:
	if isDead:
		return
	translate(direction * 0.01)
	move_and_slide()
#	if move_and_slide():
		#var collision = get_slide_collision(0)
		#if collision.get_collider().is_in_group("Punch"):
			
		
var rotation_speed: float = 0.005
func _unhandled_input(event: InputEvent) -> void:
	if isDead:
		return
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		rotation.y -= mouse_motion_event.relative.x * rotation_speed
		#rotation.x -= mouse_motion_event.relative.y * rotation_speed
		#rotation.x = clampf(rotation.x, PI/-2, PI/2)

func getDamage(damage: int):
	if isDead:
		return 
	progressBar.value -= damage
	if progressBar.value <= 0:
		isDead = true
		lowerbodyState.travel("mihalkov_death")
	else:
		animTree["parameters/OneShot 3/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if isDead:
		return
	if body.is_in_group("Enemy") and isAttacking:
		gopnikCounter += 1
		gopnikCounterText.text = str("[outline_size=10]Наказано Гопников: ", gopnikCounter, "[/outline_size]")
		body.getDamage(10)
	
