extends MarginContainer


onready var left_score_label := get_node("HBoxContainer/LeftScoreLabel")
onready var right_score_label := get_node("HBoxContainer/RightScoreLabel")
onready var winner_label := get_node("HBoxContainer/WinnerLabel")
onready var game := get_node("/root/Main/Game")


func _on_Game_pause():
	visible = true
	
	
func _on_Game_resume():
	visible = false
	
	
func _on_Game_score_updated(left_score: int, right_score: int) -> void:
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)
	visible = true
	
	
func _on_Game_point_start(_spawn_side):
	visible = false
	winner_label.visible = false


func _on_Game_end(winning_side) -> void:
	winner_label.visible = true
	if winning_side == 0:
		winner_label.text = "Left Team Wins!"
	else:
		winner_label.text = "Right Team Wins!"
