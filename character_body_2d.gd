extends CharacterBody2D

const SPEED = 600.0
var JUMP_VELOCITY = -800.0
var curr_level = 1

@onready var sprite = $Sprite2D
@onready var visibility_notifier = $Sprite2D/VisibleOnScreenNotifier2D
@onready var base_node = get_parent()
@onready var area_2d = get_node("../Area2D")

var level_1 = load("res://level_1.tscn").instantiate()
var level_2 = load("res://level_2.tscn").instantiate()

func _ready(): 
	area_2d.position = Vector2(2852.0, 247.0)
	position = Vector2.ZERO
	visibility_notifier.screen_exited.connect(_on_VisibilityNotifier2D_screen_exited)
	base_node.call_deferred("add_child", level_1)

# reset position when fall out of world
func _on_VisibilityNotifier2D_screen_exited(): 
	position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# victory flag
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		call_deferred("_go_to_next")
func _go_to_next() -> void:
	curr_level += 1
	if curr_level == 2: 
		base_node.call_deferred("add_child", level_2)
		base_node.remove_child(level_1)
		JUMP_VELOCITY = -1200
		position = Vector2.ZERO
		area_2d.position = Vector2(-1135.0, -1370.0)
	elif curr_level == 3: 
		get_tree().change_scene_to_file("res://level_3.tscn")
	else: 
		get_tree().change_scene_to_file("res://victory.tscn")
