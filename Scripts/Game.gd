extends Node2D

enum Side {
	LEFT,
	RIGHT
}

# signals
signal start			# 
signal point_start		# spawn_side
signal point_end		# collide_side
signal point_reset		# winning_side
signal end				# winning_side
signal restart			# 
signal pause			# 
signal resume			# 

# scenes
onready var volleyball = preload("res://Scenes/Volleyball.tscn")
onready var player1 = preload("res://Scenes/Player 1.tscn").instance()
onready var player2 = preload("res://Scenes/Player 2.tscn").instance()
onready var player3 = preload("res://Scenes/Player 3.tscn").instance()
onready var player4 = preload("res://Scenes/Player 4.tscn").instance()

# constants
export(int) var POINTS_TO_WIN = 11

# vars
var left_score = 0
var right_score = 0
var is_paused = false
var is_over = false
var players = []
var volleyballs = []


func _ready():
	player1.position = Vector2(player1.DEFAULT_X, player1.DEFAULT_Y)
	player2.position = Vector2(player2.DEFAULT_X, player2.DEFAULT_Y)
	players = [player1, player2]

	for player in players:
		get_parent().call_deferred("add_child", player)


func _on_Main_ready():
	emit_signal("start")


func _reset():
	left_score = 0
	right_score = 0
	is_paused = false
	is_over = false
	reset_players()


func clear_volleyballs():
	for ball in volleyballs:
		ball.queue_free()
	volleyballs.clear()


func reset_players():
	for player in players:
		player.position = Vector2(player.DEFAULT_X, player.DEFAULT_Y)


func _input(event):
	# if player hits 'esc' pause the game
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			if is_paused and not is_over:
				emit_signal("resume")
			elif not is_paused:
				emit_signal("pause")

func _on_Game_start():
	emit_signal("point_start", Side.LEFT)


func _on_Game_point_start(spawn_side):
	assert(spawn_side == Side.LEFT or spawn_side == Side.RIGHT)

	var ball = volleyball.instance()
	if spawn_side == Side.LEFT:
		ball.position = Vector2(player1.position.x, ball.DROP_HEIGHT)
	else:
		ball.position = Vector2(player2.position.x,	ball.DROP_HEIGHT)
	volleyballs.append(ball)
	get_parent().call_deferred("add_child", ball)


func _on_Volleyball_score_area_contact(_ball, side):
	emit_signal("point_end", side)


func _on_Game_point_end(collide_side):
	assert(collide_side == Side.LEFT or collide_side == Side.RIGHT)
	if collide_side == Side.LEFT:
		right_score += 1
	else:
		left_score += 1

	if left_score >= POINTS_TO_WIN:
		emit_signal("end", Side.LEFT)
	elif right_score >= POINTS_TO_WIN:
		emit_signal("end", Side.RIGHT)
	else:
		if collide_side == Side.LEFT:
			emit_signal("point_reset", Side.RIGHT)
		else:
			emit_signal("point_reset", Side.LEFT)


func _on_Game_point_reset(winning_side):
	reset_players()
	clear_volleyballs()
	emit_signal("point_start", winning_side)


func _on_Game_end(winning_side):
	assert(winning_side == Side.LEFT or winning_side == Side.RIGHT)
	clear_volleyballs()
	if winning_side == Side.LEFT:
		print("Left wins")
	else:
		print("Right wins")
	emit_signal("restart")
	
	
func _on_Game_restart():
	_reset()
	emit_signal("start")


func _on_Game_pause():
	is_paused = true
	get_tree().paused = true
	

func _on_Game_resume():
	is_paused = false
	get_tree().paused = false
