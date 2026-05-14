extends Area2D
class_name SocketComponent

signal new_socketed(socketed: DraggableComponent)
signal unsocketed

@export var target: Node2D
@export var snap_offset: Vector2 = Vector2(0, 0)

var socketed: DraggableComponent


func _ready() -> void:
	if not target:
		target = get_parent() as Node2D
	
	assert(target, "SocketComponent requires a Node2D target.")


func try_attach(candidate: DraggableComponent) -> bool:
	if not can_attach(candidate):
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
	socketed.current_socket = null
	socketed = null
	unsocketed.emit()


func can_attach(candidate: DraggableComponent) -> bool:
	return socketed == candidate or socketed == null
