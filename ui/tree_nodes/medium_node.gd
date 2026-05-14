class_name MediumNode
extends TreeNode

@export var draggable_component: DraggableComponent



func _ready() -> void:
	super._ready()
	unlockable.unlocked_changed.connect(
		func(unlocked: bool) -> void:
				draggable_component.set_enabled(not unlocked))
