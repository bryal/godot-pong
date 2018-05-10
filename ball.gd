extends Area2D

const EASING = preload("res://easing.gd")

const BALL_SPEED = 360
const START_DIR = Vector2(-1, 0)
const SCALE_FACTOR = 1.5
const SCALE_TIME = 0.3
const STRETCH_AMP = 1.2
const STRETCH_FREQ = 5
const STRETCH_TIME = 0.7

onready var initial_pos = self.position
onready var screen_h = get_viewport_rect().size.y
onready var game = get_tree().get_root().get_node("game")
onready var start_timer = get_node("start_timer")
onready var color_rect = get_node("color_rect")

var direction = START_DIR
var speed = 0
var scaler = EASING.new_constant(0)
var stretcher = EASING.new_constant(0)
var faketime_factor = 1.0

func _ready():
    start()

func _on_start_timer_timeout():
    play_ball()

func _on_area_entered(area):
    match area.get_name():
        "left", "right":
            hit_paddle(area)
        "ceiling":
            hit_ceiling()
        "floor":
            hit_floor()
        "left_wall":
            hit_wall()
            give_point_left()
        "right_wall":
            hit_wall()
            give_point_right()

func _on_game_speed_slider_value_changed(game_speed):
    self.faketime_factor = pow(2, game_speed)

func _physics_process(dt):
    var dt_faketime = dt * faketime_factor
    physics_process_faketime(dt_faketime)

func _process(dt):
    var dt_faketime = dt * faketime_factor
    process_faketime(dt_faketime)

func physics_process_faketime(dt):
    position.y = clamp(position.y, 0, screen_h)
    position += direction * speed * dt

func process_faketime(dt):
    step_scaler(dt)
    step_stretcher(dt)

func step_scaler(dt):
    var s = 1 + self.scaler.step(dt)
    color_rect.rect_scale = Vector2(s, s)

func step_stretcher(dt):
    var s = self.stretcher.step(dt)
    color_rect.rect_scale.x = color_rect.rect_scale.x * (STRETCH_AMP - s)

func set_dir(v):
    self.direction = v.normalized()
    self.rotation_degrees = rad2deg(v.angle())

func reset():
    position = initial_pos
    speed = 0
    self.set_dir(Vector2((-1) * sign(direction.x), 0))
    start()

func start():
    var timer = get_node("start_timer")
    timer.start()

func play_ball():
    play_audio("game_start")
    self.set_bounce_stretcher()
    speed = BALL_SPEED

func play_audio(name):
    get_node(name).play()

func set_bounce_scaler():
    self.scaler = EASING.new_bounce_parabola(SCALE_FACTOR - 1, SCALE_TIME)

func set_bounce_stretcher():
    self.stretcher = EASING.new_dampened_sine(STRETCH_AMP, STRETCH_FREQ, STRETCH_TIME)

func bounce():
    self.set_bounce_scaler()
    self.set_bounce_stretcher()

func hit_paddle(area):
    var dist_from_mid = position.y - area.position.y
    var paddle_height = area.height()
    var rel_dist_from_mid = dist_from_mid / (paddle_height / 2)
    var dir_x = (-1) * sign(direction.x)
    var dir_y = (rel_dist_from_mid + (randf() - 0.5) / 1.5) * 1.3
    self.set_dir(Vector2(dir_x, dir_y))
    self.bounce()
    game.camera.increase_shake_level(0.38)
    play_audio("hit_paddle")

func hit_ceil_floor(down_up):
    self.set_dir(Vector2(direction.x, down_up * abs(direction.y)))
    self.bounce()
    game.camera.increase_shake_level(0.32)
    play_audio("hit_floor_ceil")

func hit_floor():
    hit_ceil_floor(-1)

func hit_ceiling():
    hit_ceil_floor(1)

func hit_wall():
    game.camera.increase_shake_level(0.65)
    play_audio("miss")
    reset()

func give_point(side):
    var score_name = side + "_score"
    var score = game.get(score_name)
    score += 1
    game.set(score_name, score)
    game.get_node(score_name).text = str(score)

func give_point_left():
    give_point("left")

func give_point_right():
    give_point("right")
