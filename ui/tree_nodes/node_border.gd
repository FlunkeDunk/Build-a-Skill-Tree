extends Panel

@export var unlockable: UnlockableComponent
@export var clickable: ClickableComponent
@export var style_box: StyleBoxFlat
@export_range(1, 20, 1) var corner_detail: int = 2

@export_color_no_alpha var unlock_color: Color = Color(0.831, 0.686, 0.216, 1.0)
@export_color_no_alpha var locked_color: Color = Color(0.42, 0.31, 0.165, 1.0)
@export_color_no_alpha var hover_color: Color = Color(0.54, 0.42, 0.18, 1.0)


func _ready() -> void:
	if not unlockable:
		unlockable = owner.get_node("%UnlockableComponent") as UnlockableComponent
	
	assert(unlockable, "TreeNodePanel requires UnlockableComponent unlockable.")
	
	unlockable.unlocked_changed.connect(update_border)
	
	if not clickable and owner.has_node("%ClickableComponent"):
		clickable = owner.get_node("%ClickableComponent") as ClickableComponent
 
	
	if clickable:
		clickable.hovered.connect(hover_border.bind(true))
		clickable.unhovered.connect(hover_border.bind(false))
	
	setup_border()


func setup_border() -> void:
	style_box.corner_detail = corner_detail
	add_theme_stylebox_override("panel", style_box)
	update_border(unlockable.is_unlocked)

func update_border(unlocked: bool) -> void:
	style_box.bg_color = unlock_color if unlocked else locked_color


func hover_border(hovering: bool) -> void:
	if unlockable.is_unlocked:
		return
	
	#style_box.bg_color = hover_color if hovering and unlockable.can_unlock() else locked_color
	
