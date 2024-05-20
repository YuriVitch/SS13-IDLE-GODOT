extends ColorRect

signal production_button_pressed(production)

func _on_Production_Button_pressed():
	production_button_pressed.emit(self.name)
