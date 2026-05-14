class_name ClickableComponent
extends Area2D

signal pressed
signal released
signal clicked

signal right_pressed
signal right_released
signal right_clicked

signal hovered
signal unhovered

@export_range(0.1, 20, 0.1) var click_distance_tolerance: float = 5.0

var _press_position: Vector2
var _right_press_position: Vector2

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		_press_position = get_global_mouse_position()
		pressed.emit()
		_viewport.set_input_as_handled()
	
	elif event.is_action_released("click"):
		released.emit()
		var moved := get_global_mouse_position().distance_to(_press_position)
		if moved < click_distance_tolerance:
			clicked.emit()
	
	if event.is_action_pressed("right_click"):
		_right_press_position = get_global_mouse_position()
		right_pressed.emit()
		_viewport.set_input_as_handled()
	
	elif event.is_action_released("right_click"):
		right_released.emit()
		var moved := get_global_mouse_position().distance_to(_right_press_position)
		if moved < click_distance_tolerance:
			right_clicked.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		released.emit()
	if event.is_action_pressed("right_click"):
		right_released.emit()


func _on_mouse_entered() -> void:
	hovered.emit()


func _on_mouse_exited() -> void:
	unhovered.emit()
