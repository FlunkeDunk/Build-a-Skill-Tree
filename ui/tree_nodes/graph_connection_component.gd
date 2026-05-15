class_name GraphConnectionComponent
extends Node2D

@export var first_node: Node2D
@export var second_node: Node2D
@export var tree_hit_box: Area2D

var first_node_component: GraphNodeComponent
var second_node_component: GraphNodeComponent

var first_unlockable: UnlockableComponent
var second_unlockable: UnlockableComponent


var connection_line: ConnectionLine2D


func _ready() -> void:
	setup()
	
	
func setup() -> void:
	assert(first_node and second_node and first_node != second_node, "GraphConnectionComponent requires two Node2D nodes.")
	
	first_node_component = first_node.get_node("%GraphNodeComponent") as GraphNodeComponent
	second_node_component = second_node.get_node("%GraphNodeComponent") as GraphNodeComponent

	assert(first_node_component and second_node_component, "GraphConnectionComponent requires two GraphNodeComponent tree_nodes.")
	
	first_unlockable = first_node.get_node_or_null("%UnlockableComponent")
	second_unlockable = second_node.get_node_or_null("%UnlockableComponent")
	
	first_node_component.add_connection(self)
	second_node_component.add_connection(self)
	
	setup_line()


func setup_line() -> void:
	if connection_line:
		connection_line.queue_free()
	
	connection_line = ConnectionLine2D.new()
	add_child(connection_line)
	
	connection_line.start = first_node
	connection_line.end = second_node
	
	if first_unlockable and second_unlockable:
		var callable := update_line.unbind(1)
		first_unlockable.unlocked_changed.connect(callable)
		if second_unlockable != first_unlockable:
			second_unlockable.unlocked_changed.connect(callable)
	
	show_behind_parent = true
	update_line()

	if tree_hit_box:
		setup_collision()


func is_bridged() -> bool:
	if not first_unlockable or not second_unlockable:
		return false
	
	return first_unlockable.is_unlocked and second_unlockable.is_unlocked


func update_line() -> void:
	connection_line.show_connection(is_bridged())


func get_other_unlockable(unlockable: UnlockableComponent) -> UnlockableComponent:
	if first_unlockable == unlockable:
		return second_unlockable
	elif second_unlockable == unlockable:
		return first_unlockable
	
	return null
	
func get_other_node(node: Node2D) -> Node2D:
	if first_node == node:
		return second_node
	elif second_node == node:
		return first_node
	
	return null


func setup_collision() -> void:
	var collsion_shape := CollisionShape2D.new()
	var segment := SegmentShape2D.new()
	
	var first_pos := to_local(first_node.global_position)
	var second_pos := to_local(second_node.global_position)
	
	var direction: Vector2 = (second_pos - first_pos).normalized()
	
	first_pos += direction * 25
	second_pos -= direction * 25
	
	segment.a = first_pos
	segment.b = second_pos
	collsion_shape.shape = segment
	tree_hit_box.add_child(collsion_shape)


func disconnect_and_free() -> void:
	first_node_component.remove_connection(self)
	second_node_component.remove_connection(self)
	queue_free()
