extends Area2D

const BALL_SPEED = 350
const START_DIR = Vector2(-1, 0)
var direction = START_DIR
var speed = BALL_SPEED

onready var initial_pos = self.position
onready var screen_h = get_viewport_rect().size.y

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

func hit_ceiling_floor():
    direction.y = -direction.y

func hit_wall():
    reset()

func _on_area_entered(area):
    match area.get_name():
        "left", "right":
            hit_paddle(area)
        "ceiling", "floor":
            hit_ceiling_floor()
        "left_wall", "right_wall":
            hit_wall()
