extends KinematicBody2D

class_name Player


# signals
signal hit		# player, collision

# player mechanics constants
export(float) var HSPEED = 300
export(float) var VSPEED = 250
export(float) var JUMP_TIME = 1
export(float) var HOVER_TIME = 0.15
export(float) var SPIKE_TIME_COOLDOWN = 0.25
export(float) var SPIKE_SPEED_INCREASE = 150
export(float) var GRAVITY = 100

# position related
export(int) var DEFAULT_X = 1366 / 2
export(int) var DEFAULT_Y = 768 - 33 * 4	# account for imprecision (33)
export(int) var XRADIUS = 64
export(int) var YRADIUS = 32
export(int) var HORIZONTAL_PIXEL_HEIGHT = 12

# vars
var player_name = "Debug"
var velocity = Vector2()
# only one of the following three can be true at once
var jumping = false		# when player hits up
var hovering = false	# when player hits down (cancel) or jump timer runs out
var falling = false		# when hovering finishes or player hits TileMap
var spiked = false
onready var jump_timer = $JumpTimer
onready var hover_timer = $HoverTimer
onready var spike_timer = $SpikeTimer


func _ready():
	var debug = get_node("/root/Main/Debug")
	if debug:
		connect("hit", debug, "_on_Player_hit")


func _init(_player_name="Debug").():
	player_name = _player_name


func movement_horizontal():
	# conveniently defined input axes
	if Input.is_action_pressed('%s Right' % player_name):
		return 1 * HSPEED
	if Input.is_action_pressed('%s Left' % player_name):
		return -1 * HSPEED
	return 0


func movement_vertical(delta):
	# only allow jumps if player has "landed"
	if Input.is_action_pressed("%s Up" % player_name) and \
			not (jumping or hovering or falling):
		jump_start()

	# cancel jump on pressing down if jumping
	if Input.is_action_pressed("%s Down" % player_name) and jumping:
		hover_start()
	
	if jumping:
		return -1 * VSPEED
	if hovering:
		return 0
	# default to falling in case of weird behavior
	return max(1 * VSPEED, velocity.y + (GRAVITY * delta))


func jump_start():
	jumping = true
	hovering = false
	falling = false
	jump_timer.start(JUMP_TIME)


func hover_start():
	jump_timer.stop()
	jumping = false
	hovering = true
	falling = false
	hover_timer.start(HOVER_TIME)


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


func reset():
	land()


# bounce ball from player's center
func player_bounce(ball, vel):
	var center_x = position.x
	var center_y = position.y - YRADIUS
	var ball_x = ball.position.x
	var ball_y = ball.position.y

	var direction = Vector2(ball_x - center_x, ball_y - center_y).normalized()
	return direction * vel.length()


func _physics_process(delta):
	velocity.x = movement_horizontal()
	velocity.y = movement_vertical(delta)

	var collision = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision)

		# working solution so player doesn't freeze on collision
		velocity = move_and_slide(velocity)

		if collision.collider.get_class() != "TileMap": 
			emit_signal("hit", self, collision)


func _on_collision(collision):
	if collision.collider.get_class() == "TileMap":
		land()


func _on_JumpTimer_timeout():
	hover_start()


func _on_HoverTimer_timeout():
	fall_start()


func _on_SpikeTimer_timeout():
	spiked = false


func _on_Volleyball_spike_hit(ball, player):
	# spikes permanently increase speed of ball
	if not spiked:
		ball.min_speed += player.SPIKE_SPEED_INCREASE
		spike_timer.start(SPIKE_TIME_COOLDOWN)
		spiked = true
