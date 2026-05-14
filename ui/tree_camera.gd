extends Camera2D

@export_range(0.02, 20, 0.02) var min_zoom := 0.1
@export_range(0.02, 20, 0.02) var max_zoom := 2.0
@export_range(0.01, 1, 0.01) var zoom_factor := 0.2
@export_range(0.01, 1, 0.01) var zoom_duration := 0.2
var zoom_level: float = 1
var position_before_drag: Vector2
var position_before_drag2: Vector2
var dragging: bool = false



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level * (1 + zoom_factor))
	elif event.is_action_pressed("zoom_out"):
		set_zoom_level(zoom_level / (1 + zoom_factor))
	elif event.is_action_pressed("camera_drag"):
		position_before_drag = event.global_position
		position_before_drag2 = self.global_position
		dragging = true
	elif event.is_action_released("camera_drag"):
		dragging = false
	
	if dragging and event is InputEventMouseMotion:
		self.global_position = position_before_drag2 + (position_before_drag - event.global_position) / zoom_level


func set_zoom_level(level: float, mouse_world_position: Vector2 = self.get_global_mouse_position()) -> void:
	var old_zoom_level: float = zoom_level
	
	zoom_level = clampf(level, min_zoom, max_zoom)
	
	var direction: Vector2 = (mouse_world_position - self.global_position)
	var zoom_ratio: float = old_zoom_level / zoom_level
	var new_position: Vector2 = self.global_position + direction * (1.0 - zoom_ratio)
	
	self.zoom = Vector2(zoom_level, zoom_level)
	self.global_position = new_position
