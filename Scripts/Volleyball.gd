extends KinematicBody2D

class_name Volleyball

signal collision
var gravity = 100
var velocity = Vector2()
export var min_speed = 500.0;


func _ready():
	velocity.y = min_speed


func _physics_process(delta):
	velocity.y += gravity * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity = move_and_slide(velocity)
		emit_signal("collision", self, collision.collider)

	if velocity.x == 0:
		velocity.x = 0.1 if randi() % 2 else -0.1
	if velocity.length() < min_speed:
		velocity = velocity.normalized() * min_speed
