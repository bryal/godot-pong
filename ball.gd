extends Area2D

const BALL_SPEED_DEFAULT = 360
const START_DIR = Vector2(-1, 0)
var direction = START_DIR
var ball_speed_active
var speed = 0

onready var initial_pos = self.position
onready var screen_h = get_viewport_rect().size.y
onready var game = get_tree().get_root().get_node("game")
onready var start_timer = get_node("start_timer")

func _ready():
    match_ball_speed_to_game_speed(0)
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
    match_ball_speed_to_game_speed(game_speed)

func _physics_process(dt):
    position.y = clamp(position.y, 0, screen_h)
    position += direction * speed * dt


func set_dir(v):
    self.direction = v.normalized()
    self.rotation_degrees = rad2deg(v.angle())

func match_ball_speed_to_game_speed(game_speed):
    ball_speed_active = BALL_SPEED_DEFAULT * pow(2, game_speed)
    if speed != 0:
        speed = ball_speed_active

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
    speed = ball_speed_active

func play_audio(name):
    get_node(name).play()

func hit_paddle(area):
    var dist_from_mid = position.y - area.position.y
    var paddle_height = area.height()
    var rel_dist_from_mid = dist_from_mid / (paddle_height / 2)
    var dir_x = (-1) * sign(direction.x)
    var dir_y = (rel_dist_from_mid + (randf() - 0.5) / 1.5) * 1.3
    self.set_dir(Vector2(dir_x, dir_y))
    game.camera.increase_shake_level(0.38)
    play_audio("hit_paddle")

func hit_ceil_floor(down_up):
    self.set_dir(Vector2(direction.x, down_up * abs(direction.y)))
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
