extends KinematicBody2D

var gravity = 100
var velocity = Vector2()

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += gravity * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
