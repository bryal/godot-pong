extends Area2D

const EASING = preload("res://easing.gd")

const BALL_SPEED = 360
const START_DIR = Vector2(-1, 0)
const SCALE_FACTOR = 3
const SCALE_TIME = 0.2
const L_STRETCH_AMP = 1.9
const L_STRETCH_FREQ = 5
const L_STRETCH_TIME = 0.8
const W_STRETCH_AMP = 2
const W_STRETCH_FREQ = 5
const W_STRETCH_TIME = 0.4
const FLASH_STRENGTH = 1.0
const FLASH_TIME = 0.2
const FLASH_COLORS = [Color(0.9, 0.7, 0.4), Color(0.7, 0.9, 0.5), Color(0.5, 0.7, 0.9), Color(0.9, 0.4, 0.8), Color(0.9, 0.4, 0.4)]
const WHITE = Color(1, 1, 1)

onready var initial_pos = self.position
onready var screen_h = get_viewport_rect().size.y
onready var game = get_tree().get_root().get_node("game")
onready var start_timer = get_node("start_timer")
onready var color_rect = get_node("color_rect")

var direction = START_DIR
var scaler = EASING.new_constant(0)
var length_stretcher = EASING.new_constant(1)
var width_stretcher = EASING.new_constant(1)
var flasher = EASING.new_constant(0)
var flash_color = FLASH_COLORS[0]
var speed = 0
var speeder = EASING.new_constant(0)
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
            game.give_point_left()
        "right_wall":
            hit_wall()
            game.give_point_right()

func _on_game_speed_slider_value_changed(game_speed):
    self.faketime_factor = pow(2, game_speed)

func _physics_process(dt):
    var dt_faketime = dt * faketime_factor
    physics_process_faketime(dt_faketime)

func _process(dt):
    var dt_faketime = dt * faketime_factor
    process_faketime(dt_faketime)

func physics_process_faketime(dt):
    step_speeder(dt)
    position.y = clamp(position.y, 1, screen_h - 1)
    position += direction * speed * dt

func process_faketime(dt):
    step_scaler(dt)
    step_stretcher(dt)
    step_flasher(dt)

func step_speeder(dt):
    self.speed = self.speeder.step(dt)

func step_scaler(dt):
    var s = 1 + self.scaler.step(dt)
    color_rect.rect_scale = Vector2(s, s)

func step_stretcher(dt):
    color_rect.rect_scale.x = color_rect.rect_scale.x * self.length_stretcher.step(dt)
    color_rect.rect_scale.y = color_rect.rect_scale.y * self.width_stretcher.step(dt)

func step_flasher(dt):
    var strength = self.flasher.step(dt)
    color_rect.color = WHITE.linear_interpolate(self.flash_color, strength)

func set_dir(v):
    self.direction = v.normalized()
    self.rotation_degrees = rad2deg(v.angle())

func reset():
    position = initial_pos
    speeder = EASING.new_constant(0)
    self.set_dir(Vector2((-1) * sign(direction.x), 0))
    start()

func start():
    var timer = get_node("start_timer")
    timer.start()

func play_ball():
    play_audio("game_start")
    self.set_bounce_stretcher()
    self.set_bounce_speeder()
    speed = BALL_SPEED

func play_audio(name):
    get_node(name).play()

func set_bounce_scaler():
    self.scaler = EASING.new_bounce_parabola(SCALE_FACTOR - 1, SCALE_TIME)

func set_bounce_stretcher():
    self.length_stretcher = EASING.new_squeezer(L_STRETCH_AMP, L_STRETCH_FREQ, L_STRETCH_TIME)
    self.width_stretcher = EASING.new_stretcher(W_STRETCH_AMP, W_STRETCH_FREQ, W_STRETCH_TIME)

func set_bounce_flasher():
    self.flasher = EASING.new_bounce_parabola(FLASH_STRENGTH, FLASH_TIME)
    var i = randi() % len(FLASH_COLORS)
    self.flash_color = FLASH_COLORS[i]

func set_bounce_speeder():
    self.speeder = EASING.new_linear(0, BALL_SPEED, 0.15)

func bounce():
    self.set_bounce_scaler()
    self.set_bounce_stretcher()
    self.set_bounce_flasher()
    self.set_bounce_speeder()

func hit_paddle(paddle):
    var dist_from_mid = position.y - paddle.position.y
    var rel_dist_from_mid = dist_from_mid / (paddle.height / 2.0)
    var dir_x = (-1) * sign(direction.x)
    var dir_y = (rel_dist_from_mid + (randf() - 0.5) / 1.5) * 1.3
    self.set_dir(Vector2(dir_x, dir_y))
    self.bounce()
    paddle.hit()
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
