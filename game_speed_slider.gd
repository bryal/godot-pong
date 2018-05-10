extends HSlider

var game_speed = 0

func _on_game_speed_slider_value_changed(new_speed):
	for player in get_tree().get_nodes_in_group("samples"):
		var old_factor = pow(2, game_speed * 0.7)
		var new_factor = pow(2, new_speed * 0.7)
		player.stream.mix_rate = (player.stream.mix_rate / old_factor) * new_factor
	game_speed = new_speed
		

