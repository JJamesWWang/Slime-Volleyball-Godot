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
onready var fall_timer = $FallTimer


func movement_horizontal():
    if Input.is_action_pressed('right'):
        return 1 * hspeed
    if Input.is_action_pressed('left'):
        return -1 * hspeed
    return 0


func movement_vertical():
    if Input.is_action_pressed("up") and not (jumping or hovering or falling):
        jump_start()
    if Input.is_action_pressed("down") and jumping:
        hover_start()
    
    if jumping:
        return -1 * vspeed
    if falling:
        return 1 * vspeed
    return 0    # hovering also returns 0


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
    hover_timer.stop()
    jumping = false
    hovering = false
    falling = true
    fall_timer.start(jump_time - jump_timer.time_left)


func land():
    fall_timer.stop()
    jumping = false
    hovering = false
    falling = false


func _physics_process(delta):
    var velocity = Vector2()
    velocity.x = movement_horizontal()
    velocity.y = movement_vertical()

    velocity = move_and_slide(velocity)
    if velocity.y == 0 and not hovering:
        land()


func _on_JumpTimer_timeout():
    hover_start()


func _on_HoverTimer_timeout():
    fall_start()


func _on_FallTimer_timeout():
    land()