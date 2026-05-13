extends Area2D
class_name SocketComponent

@export var target: Node2D
@export var snap_offset: Vector2 = Vector2(0, 0)

var attached: DraggableComponent


func _ready() -> void:
	if not target:
		target = get_parent() as Node2D
	assert(target != null, "SocketComponent requires a Node2D target.")


func try_attach(candidate: DraggableComponent) -> bool:
	if attached:
		return false

	if candidate.current_socket:
		candidate.current_socket.un_attach()

	attached = candidate
	candidate.current_socket = self

	candidate.target.reparent(target, true)
	candidate.target.global_position = target.global_position

	return true

func un_attach():
	attached.current_socket = null
	attached = null

func can_attach(candidate: DraggableComponent) -> bool:
	return attached == null
