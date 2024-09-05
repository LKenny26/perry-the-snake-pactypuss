extends CharacterBody2D

class_name Player

# adapted from this tutorial: https://www.youtube.com/watch?v=CncJvOEM3OA&t=932s

var next_movement_direction: Vector2 = Vector2.ZERO
var movement_direction: Vector2 = Vector2.ZERO
var shape_query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()

@export var speed: int = 150

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var direction_pointer: Sprite2D = $DirectionPointer
@onready var body_collider: CollisionShape2D = $BodyCollider


func _ready() -> void:
	shape_query.shape = body_collider.shape
	shape_query.collision_mask = 2


func _physics_process(delta: float) -> void:
	get_input()
	
	# player starts with no movement, update instantly on first directional input
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction
		
	# only update movement_direction when there's a gap in the walls
	if can_move_in_direction(next_movement_direction, delta):
		movement_direction = next_movement_direction
		sprite_2d.rotation = movement_direction.angle() + PI / 2
	
	velocity = movement_direction * speed
	move_and_slide()
	
	
func get_input() -> void:
	if Input.is_action_pressed("left"):
		next_movement_direction = Vector2.LEFT
		
	elif Input.is_action_pressed("right"):
		next_movement_direction = Vector2.RIGHT
		
	elif Input.is_action_pressed("up"):
		next_movement_direction = Vector2.UP
		
	elif Input.is_action_pressed("down"):
		next_movement_direction = Vector2.DOWN
		
	# this is a visual indicator for the next direction the player wants to move
	if next_movement_direction != Vector2.ZERO:
		direction_pointer.position = next_movement_direction * direction_pointer.position.length()
	
		
# kinda "raycasts" a shape into the next direction to see if theres a wall there
func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0
