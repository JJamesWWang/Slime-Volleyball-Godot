extends KinematicBody2D

var gravity = 100
var velocity = Vector2()
export var drop_speed = 500.0;

func _ready():
	velocity.y = drop_speed


func _physics_process(delta):
	velocity.y += gravity * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity = move_and_slide(velocity)
