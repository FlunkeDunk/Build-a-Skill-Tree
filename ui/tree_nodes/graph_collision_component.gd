class_name GraphCollisionComponent
extends Node

@export var shape: Shape2D

var collision_shape: CollisionShape2D

func _ready() -> void:
	var tree_hit_box := owner.owner.get_node_or_null("%TreeHitBox") as TreeHitBox
	
	if tree_hit_box:
		setup_collision(tree_hit_box)


func setup_collision(tree_hit_box: TreeHitBox) -> void:
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	tree_hit_box.add_child(collision_shape)
	collision_shape.global_position = owner.global_position



func enable() -> void:
	if collision_shape:
		collision_shape.disabled = false

func disable() -> void:
	if collision_shape:
		collision_shape.disabled = true
