class_name DraggableComponent extends Area2D


signal drag_started
signal drag_ended

@export var target: Node2D
@export var dragging_z_index: int = 2

@export_category("Smooth motion")
@export var smoothing: bool = false
@export_range(0.1, 100.0, 0.1) var smooth_responsiveness := 10.0


var start_position: Vector2
var original_z_index: int

var overlapping_sockets: Array[SocketComponent]
var current_socket: SocketComponent


var is_dragging: bool = false:
	set(value):
		if is_dragging == value:
			return
		is_dragging = value
		if value:
			start_position = target.global_position
			original_z_index = target.z_index
			target.z_index = dragging_z_index
			drag_started.emit()
			set_process(true)
		else:
			drag_ended.emit()
			target.z_index = original_z_index
			set_process(false)
			for socket: SocketComponent in overlapping_sockets:
				if socket.try_attach(self):
					current_socket = socket
					return
			if current_socket:
				target.global_position = start_position
		
var mouse_inside: bool

func _ready() -> void:
	set_process(false)
	if not target:
		target = get_parent() as Node2D
	
	assert(target != null, "DraggableComponent requires a Node2D target.")

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	
	if smoothing:
		# avoids frame dependent smoothing
		var weight := 1.0 - exp(-smooth_responsiveness * delta)
		target.global_position = target.global_position.lerp(mouse_pos, weight)
	else:
		target.global_position = mouse_pos
		
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		is_dragging = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		is_dragging = false


func _on_area_entered(area: Area2D) -> void:
	if area is SocketComponent:
		overlapping_sockets.append(area)
		

func _on_area_exited(area: Area2D) -> void:
	if area is SocketComponent:
		overlapping_sockets.erase(area)
