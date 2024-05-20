extends ColorRect

signal ore_button_pressed(ore)

func _on_ore_mining_pressed():
	ore_button_pressed.emit(self.name)
