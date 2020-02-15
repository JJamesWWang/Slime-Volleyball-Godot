extends KinematicBody2D

class_name Player


export(float) var hspeed = 300
export(float) var vspeed = 250
export(float) var jump_time = 1
export(float) var hover_time = 0.15
export(float) var spike_speed_increase = 150

export(int) var default_x = 1366 / 2
export(int) var default_y = 768 - 32 * 4

export(int) var xradius = 64
export(int) var yradius = 32
export(int) var horizontal_pixel_height = 12
var player_name = "Debug"

# only one of the following three can be true at once
var jumping = false
var hovering = false
var falling = false
onready var jump_timer = $JumpTimer
onready var hover_timer = $HoverTimer


func _init(_player_name="Debug").():
	player_name = _player_name


func movement_horizontal():
	if Input.is_action_pressed('%s Right' % player_name):
		return 1 * hspeed
	if Input.is_action_pressed('%s Left' % player_name):
		return -1 * hspeed
	return 0


func movement_vertical():
	if Input.is_action_pressed("%s Up" % player_name) and \
			not (jumping or hovering or falling):
		jump_start()
	if Input.is_action_pressed("%s Down" % player_name) and jumping:
		hover_start()
	
	if jumping:
		return -1 * vspeed
	if hovering:
		return 0
	return 1 * vspeed


func jump_start():
	jumping = true
	hovering = false
	falling = false
	jump_timer.start(jump_time)


func hover_start():
	jump_timer.stop()
	jumping = false
	hovering = true
	falling = false
	hover_timer.start(hover_time)


func fall_start():
	jump_timer.stop()
	hover_timer.stop()
	jumping = false
	hovering = false
	falling = true


func land():
	jump_timer.stop()
	hover_timer.stop()
	jumping = false
	hovering = false
	falling = false


# bounce ball from player's center
func player_bounce(ball, velocity):
	var center_x = position.x
	var center_y = position.y - yradius
	var ball_x = ball.position.x
	var ball_y = ball.position.y

	var direction = Vector2(ball_x - center_x, ball_y - center_y).normalized()
	return direction * velocity.length()




func _physics_process(delta):
	var velocity = Vector2()
	velocity.x = movement_horizontal()
	velocity.y = movement_vertical()

	var collision = move_and_collide(velocity * delta)
	if collision:
		_on_Collision(collision)
		velocity = move_and_slide(velocity)


func _on_Collision(collision):
	if collision.collider.get_class() == "TileMap":
		land()


func _on_JumpTimer_timeout():
	hover_start()


func _on_HoverTimer_timeout():
	fall_start()


func _on_FallTimer_timeout():
	land()


func _on_Volleyball_spike_hit(ball, player):
	ball.min_speed += player.spike_speed_increase
