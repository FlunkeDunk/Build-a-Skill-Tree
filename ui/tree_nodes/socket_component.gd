extends Area2D
class_name SocketComponent


signal try_attach_begun
signal try_attach_failed
signal new_socketed(socketed: DraggableComponent)
signal unsocketed

@export var target: Node2D
@export var snap_offset: Vector2 = Vector2(0, 0)

var socketed: DraggableComponent


func _ready() -> void:
	if not target:
		target = get_parent() as Node2D
	
	
	collision_layer = 0b00010000
	collision_mask = 0b00010000
	assert(target, "SocketComponent requires a Node2D target.")


func try_attach(candidate: DraggableComponent) -> bool:
	try_attach_begun.emit()
	if not can_attach(candidate):
		try_attach_failed.emit()
		return false
	
	if candidate.current_socket:
		candidate.current_socket.un_attach()

	socketed = candidate
	candidate.current_socket = self

	candidate.target.reparent(target, true)
	candidate.target.position = snap_offset
	new_socketed.emit(candidate)
	return true


func un_attach() -> void:
	socketed.target.reparent(socketed.original_target_parent)
	socketed.current_socket = null
	socketed = null
	unsocketed.emit()


func can_attach(candidate: DraggableComponent) -> bool:
	if socketed == candidate:
		return true
	if socketed:
		return false
	
	var test_transform := Transform2D(candidate.target.global_rotation, target.global_position)
	var collided := candidate.would_collide_at_transform(test_transform)
	print("socket collision result is ", collided)
	return not collided
	
	
	
