extends Node2D

export var size = Vector2.ZERO

onready var platform = get_node("Platform")

onready var sprite = get_node("Platform/Sprite")
onready var collision = get_node("Platform/CollisionShape2D")


func _ready():
	sprite.set_scale(size/2)
	collision.get_shape().set_extents(Vector2(size.x * 32 / 2, size.y * 32 / 2))
