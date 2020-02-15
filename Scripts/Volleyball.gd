extends KinematicBody2D

class_name Volleyball

signal collision
signal score_area_contact
signal spike_hit
var gravity = 100
var velocity = Vector2()
export var min_speed = 300.0;
export(int) var radius = 16


func _ready():
	velocity.y = min_speed


func _physics_process(delta):
	velocity.y += gravity * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity = move_and_slide(velocity)
		_emit_signals(collision)
	
	if velocity.x == 0:
		velocity.x = 0.1 if randi() % 2 else -0.1
	if velocity.length() < min_speed:
		velocity = velocity.normalized() * min_spee


func _emit_signals(collision):
	emit_signal("collision", self, collision)

	var collider = collision.collider
	if collider.is_class("TileMap") and "side" in collider:
		emit_signal("score_area_contact", self, collider.side)
	if collider is Player:
		_detect_spike_hit(collider)
d


func _detect_spike_hit(player):
	var ball_y = position.y
	var player_y = player.position.y

	# if (the middle of the ball) (is =below) (top of vertical part of slime)
	#   and (the top of the ball) (is above) (bottom of the slime) 
	if ball_y >= player_y - player.horizontal_pixel_height and \
			ball_y - radius < player_y:
		emit_signal("spike_hit", self, player)

