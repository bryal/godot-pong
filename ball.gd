extends Area2D

const BALL_SPEED = 300
const START_DIR = Vector2(-1, 0)
var direction = START_DIR
var speed = BALL_SPEED

onready var initial_pos = self.position

func reset():
    position = initial_pos
    speed = BALL_SPEED
    direction = START_DIR

func _process(delta):
    position += direction * speed * delta

func hit_paddle(area):
    var dist_from_mid = position.y - area.position.y
    var paddle_height = area.get_node("collision").shape.extents.y
    var rel_dist_from_mid = dist_from_mid / paddle_height
    var dir_y = rel_dist_from_mid * 2
    direction = Vector2((-1) * sign(direction.x), dir_y).normalized()

func hit_ceiling_floor():
    direction.y = -direction.y

func _on_area_entered(area):
    match area.get_name():
        "left", "right":
            hit_paddle(area)
        "ceiling", "floor":
            hit_ceiling_floor()
