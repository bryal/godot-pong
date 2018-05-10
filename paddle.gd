extends Area2D

const MOVE_SPEED = 280
onready var screensize = get_viewport_rect().size

func height():
    return get_node("collision").shape.extents.y * 2

func top():
    return position.y - height() / 2

func bottom():
    return position.y + height() / 2

func _process(delta):
    var which = get_name()
    var h = height()
    # move up and down based on input
    if Input.is_action_pressed(which+"_move_up") and top() > 0:
        position.y -= MOVE_SPEED * delta
    if Input.is_action_pressed(which+"_move_down") and bottom() < screensize.y:
        position.y += MOVE_SPEED * delta
