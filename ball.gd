extends Area2D

const BALL_SPEED = 350
const START_DIR = Vector2(-1, 0)
var direction = START_DIR
var speed = BALL_SPEED

onready var initial_pos = self.position
onready var screen_h = get_viewport_rect().size.y
onready var game = get_tree().get_root().get_node("game")

func reset():
    position = initial_pos
    speed = BALL_SPEED
    direction = Vector2((-1) * sign(direction.x), 0)

func _process(delta):
    clamp(position.y, 0, screen_h)
    position += direction * speed * delta

func flip_x_dir():
    direction.x = (-1) * sign(direction.x)

func hit_paddle(area):
    var dist_from_mid = position.y - area.position.y
    var paddle_height = area.height()
    var rel_dist_from_mid = dist_from_mid / (paddle_height / 2)
    direction.y = (rel_dist_from_mid + (randf() - 0.5) / 2) * 1.2
    flip_x_dir()
    direction = direction.normalized()
    game.camera.increase_shake_level(0.38)

func hit_ceil_floor(down_up):
    direction.y = down_up * abs(direction.y)
    game.camera.increase_shake_level(0.32)

func hit_floor():
    hit_ceil_floor(-1)

func hit_ceiling():
    hit_ceil_floor(1)

func hit_wall():
    game.camera.increase_shake_level(0.65)
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
