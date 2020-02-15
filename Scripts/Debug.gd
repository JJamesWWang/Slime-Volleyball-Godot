extends Node2D


func _on_Game_start():
	print_debug("Signal emitted: Game Start")


func _on_Game_point_start():
	print_debug("Signal emitted: Point Start")


func _on_Game_point_end():
	print_debug("Signal emitted: Point End")


func _on_Game_score_update():
	print_debug("Signal emitted: Score Update")


func _on_Game_pause():
	print_debug("Signal emitted: Pause")


func _on_Game_resume():
	print_debug("Signal emitted: Resume")


func _on_Game_end():
	print_debug("Signal emitted: Game End")


func _on_Volleyball_collision(_volleyball, _collider):
	print_debug("Signal emitted: Volleyball Collision")


func _on_Volleyball_score_area_contact(_volleyball, _side):
	print_debug("Signal emitted: Score Area Contact")


func _on_Volleyball_spike_hit(_volleyball, _player):
	print_debug("Signal emitted: Spike hit");