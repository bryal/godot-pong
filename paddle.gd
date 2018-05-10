extends Area2D

const MOVE_SPEED_DEFAULT = 280
var move_speed
onready var screensize = get_viewport_rect().size

func _ready():
    match_paddle_speed_to_game_speed(0)

func match_paddle_speed_to_game_speed(game_speed):
    move_speed = MOVE_SPEED_DEFAULT * pow(2, game_speed)

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
        position.y -= move_speed * delta
    if Input.is_action_pressed(which+"_move_down") and bottom() < screensize.y:
        position.y += move_speed * delta


func _on_game_speed_slider_value_changed(game_speed):
    match_paddle_speed_to_game_speed(game_speed)
