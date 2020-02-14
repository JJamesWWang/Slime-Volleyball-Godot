extends KinematicBody2D

export (float) var hspeed = 200;
export (float) var vspeed = 100;
export (float) var jump_time = 1;
export (float) var hover_time = 0.15;

# only one of the following three can be true at once
var jumping = false
var hovering = false
var falling = false
onready var jump_timer = $JumpTimer
onready var hover_timer = $HoverTimer


func movement_horizontal():
	if Input.is_action_pressed('Debug Right'):
		return 1 * hspeed
	if Input.is_action_pressed('Debug Left'):
		return -1 * hspeed
	return 0


func movement_vertical():
	if Input.is_action_pressed("Debug Up") and not (jumping or hovering or falling):
		jump_start()
	if Input.is_action_pressed("Debug Down") and jumping:
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
