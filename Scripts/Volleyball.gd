extends KinematicBody2D

class_name Volleyball

# signals
signal collision				# ball, collision
signal score_area_contact		# ball, side
signal spike_hit				# ball, player

# constants
export(int) var RADIUS = 16
var GRAVITY = 100

# vars
var velocity = Vector2()
export var min_speed = 300.0;


func _ready():
	velocity.y = min_speed


func _physics_process(delta):
	velocity.y += GRAVITY * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.collider

		# bounce differently depending on whether it's a Player or TileMap
		if collider is Player:
			velocity = collider.player_bounce(self, velocity)
		else:
			velocity = velocity.bounce(collision.normal)

		# slide so collisions don't freeze ball (working solution)
		velocity = move_and_slide(velocity)
		_emit_signals(collision)
	
	# prevent ball from getting stuck on one side
	if velocity.x == 0:
		velocity.x = 0.1 if randi() % 2 else -0.1
	
	# ensure ball always has certain speed (slow down would be boring)
	if velocity.length() < min_speed:
		velocity = velocity.normalized() * min_speed


func _emit_signals(collision):
	emit_signal("collision", self, collision)

	var collider = collision.collider
	if collider.is_class("TileMap") and "side" in collider:
		emit_signal("score_area_contact", self, collider.side)
	if collider is Player:
		_detect_spike_hit(collider)


func _detect_spike_hit(player):
	var ball_y = position.y
	var player_y = player.position.y

	# if (the middle of the ball) (is =below) (top of vertical part of slime)
	#   and (the top of the ball) (is above) (bottom of the slime) 
	if ball_y >= player_y - player.HORIZONTAL_PIXEL_HEIGHT and \
			ball_y - RADIUS < player_y:
		emit_signal("spike_hit", self, player)

