extends Node2D


func _on_Game_start():
	print("Signal emitted: Game Start")


func _on_Game_point_start(_side):
	print("Signal emitted: Point Start")


func _on_Game_point_end(_side):
	print("Signal emitted: Point End")


func _on_Game_point_reset(_side):
	print("Signal emitted: Point Reset")


func _on_Game_pause():
	print("Signal emitted: Pause")


func _on_Game_resume():
	print("Signal emitted: Resume")


func _on_Game_end(_side):
	print("Signal emitted: Game End")


func _on_Game_restart():
	print("Signal emitted: Game Restart")
	

func _on_Volleyball_collision(_volleyball, _collider):
	print("Signal emitted: Volleyball Collision")


func _on_Volleyball_score_area_contact(_volleyball, _side):
	print("Signal emitted: Score Area Contact")


func _on_Volleyball_spike_hit(_volleyball, _player):
	print("Signal emitted: Spike hit");