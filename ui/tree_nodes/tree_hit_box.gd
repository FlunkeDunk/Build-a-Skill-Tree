class_name TreeHitBox
extends Area2D


func _ready() -> void:
	collision_layer = 0b00100000
	collision_mask = 0b00100000
