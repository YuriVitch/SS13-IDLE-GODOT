extends Node2D

signal item_gain(item, amount)

var newInputs := preload("res://resources/scripts/Inputs.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#item_gain.emit(1,1)
	#var __ = get_node("../Inventory").connect("sprite_created", self, "_on_InitWorld_sprite_created")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed(newInputs.INPUT_CLICK):
		item_gain.emit('click', 1)
		print('input')
