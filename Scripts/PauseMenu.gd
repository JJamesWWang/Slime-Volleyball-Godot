extends Panel


signal restart_clicked

onready var paused_label = $PausedLabel


func _on_Game_pause() -> void:
	visible = true
	
	
func _on_Game_resume() -> void:
	visible = false


func _on_RestartButton_pressed() -> void:
	emit_signal("restart_clicked")


func _on_restart_clicked() -> void:
	visible = false


func _on_Game_end(_winning_side) -> void:
	paused_label.visible = false
