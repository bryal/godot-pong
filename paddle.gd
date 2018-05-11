extends Area2D

const EASING = preload("res://easing.gd")

const MOVE_SPEED = 280
const STRETCH_AMP = 1.2
const STRETCH_FREQ = 4.5
const STRETCH_TIME = 0.25

onready var screensize = get_viewport_rect().size
onready var height = get_node("collision").shape.extents.y * 2
onready var side = get_name()
onready var color_rect = get_node("color_rect")

var x_stretcher = EASING.new_constant(1)
var y_stretcher = EASING.new_constant(1)
var faketime_factor = 1.0

func _process(dt):
    var dt_faketime = dt * faketime_factor
    process_faketime(dt_faketime)

func _on_game_speed_slider_value_changed(game_speed):
    faketime_factor = pow(2, game_speed)


func process_faketime(dt):
    # move up and down based on input
    if Input.is_action_pressed(side+"_move_up"):
        position.y -= MOVE_SPEED * dt
    if Input.is_action_pressed(side+"_move_down"):
        position.y += MOVE_SPEED * dt
    position.y = clamp(position.y, height / 2.0, screensize.y - height / 2.0)
    step_stretcher(dt)

func step_stretcher(dt):
    color_rect.rect_scale.x = self.x_stretcher.step(dt)
    color_rect.rect_scale.y = self.y_stretcher.step(dt)

func set_hit_stretcher():
    self.x_stretcher = EASING.new_squeezer(STRETCH_AMP, STRETCH_FREQ, STRETCH_TIME)
    self.y_stretcher = EASING.new_stretcher(STRETCH_AMP, STRETCH_FREQ, STRETCH_TIME)

func hit():
    self.set_hit_stretcher()
