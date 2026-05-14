class_name DraggableComponent
extends Node2D

signal drag_started
signal drag_ended


@export var target: Node2D
@export var clickable: ClickableComponent

@export var dragging_z_index := 2
@export_range(0, 100, 1) var begin_dragging_threshold := 8

@export_category("Smooth Motion")
@export var smoothing := false
@export_range(0.1, 100.0, 0.1) var smooth_responsiveness := 10.0


var start_position: Vector2
var mouse_start_position: Vector2
var original_z_index: int

var current_socket: SocketComponent
var crossed_threshold := false
var _is_dragging := false
var enabled: bool = true



func _ready() -> void:
	set_process(false)

	target = target if target else get_parent() as Node2D
	assert(target, "DraggableComponent requires a Node2D target.")

	if not clickable:
		clickable = owner.get_node_or_null("%ClickableComponent")

	assert(clickable, "DraggableComponent requires a ClickableComponent.")

	clickable.pressed.connect(_begin_drag)
	clickable.released.connect(_end_drag)


func _process(delta: float) -> void:
	var desired_position := get_global_mouse_position() + _dragging_offset()

	if not crossed_threshold:
		if start_position.distance_to(desired_position) < begin_dragging_threshold:
			return

		crossed_threshold = true
		original_z_index = target.z_index
		target.z_index = dragging_z_index
		drag_started.emit()

	if smoothing:
		var weight := 1.0 - exp(-smooth_responsiveness * delta)
		target.global_position = target.global_position.lerp(desired_position, weight)
	else:
		target.global_position = desired_position


func _begin_drag() -> void:
	if not enabled or _is_dragging:
		return

	_is_dragging = true
	crossed_threshold = false

	start_position = target.global_position
	mouse_start_position = get_global_mouse_position()

	set_process(true)


func _end_drag() -> void:
	if not _is_dragging:
		return

	_is_dragging = false
	set_process(false)

	target.z_index = original_z_index

	if crossed_threshold:
		_try_attach()

	drag_ended.emit()


func _try_attach() -> void:
	for socket: SocketComponent in clickable.get_overlapping_areas().filter(func(area: Area2D) -> bool:return area is SocketComponent):
		if socket.try_attach(self):
			current_socket = socket
			return

	# Snap back if no socket accepted
	if current_socket:
		current_socket.un_attach()
	current_socket = null


func _dragging_offset() -> Vector2:
	return start_position - mouse_start_position


func set_enabled(value: bool) -> void:
	enabled = value
