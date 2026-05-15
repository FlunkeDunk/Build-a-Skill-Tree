class_name TreeNode
extends Node2D


@export var unlockable: UnlockableComponent
@export var clickable: ClickableComponent
@export var hit_box: TreeHitBox
@onready var distance_label: Label = $distance_label


func _ready() -> void:
	assert(clickable and unlockable, "TreeNode needs UnlockableComponent and ClickableComponent")
	clickable.clicked.connect(unlockable.try_unlock)
	clickable.right_clicked.connect(unlockable.try_lock)
	
	unlockable.unlocked_changed.connect((
		func() -> void: distance_label.text = str(unlockable.distance_to_source)).unbind(1))
