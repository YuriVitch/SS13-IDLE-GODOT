extends ColorRect

signal sell_all(item, amount)


func _on_sell_one_pressed():
	sell_all.emit(get_child(1).name, 1)

func _on_sell_all_pressed():
	sell_all.emit(get_child(1).name, 'all')
