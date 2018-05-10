extends Camera2D

const SHAKE_RESET_TIME_DEFAULT = 1.2
var shake_reset_time
const SHAKE_MAX_OFFSET = 30
const SHAKE_MAX_ANGLE = 10 # degrees
const SHAKE_FREQ_DEFAULT = 14
var shake_freq

var shake_level = 0.0
var t = 0.0
var p0
var p1
var p2

func _ready():
    match_shake_to_game_speed(0)
    var sn = preload("res://SoftNoise/softnoise.gd")
    p0 = sn.SoftNoise.new(0)
    p1 = sn.SoftNoise.new(1)
    p2 = sn.SoftNoise.new(2)

func match_shake_to_game_speed(game_speed):
    shake_freq = SHAKE_FREQ_DEFAULT * pow(2, game_speed)
    shake_reset_time = SHAKE_RESET_TIME_DEFAULT / pow(2, game_speed)

# Perlin noise for the generator `p` at time `t`. Result in range [-1, 1]
func perlin(p, t):
    var v = p.perlin_noise2d(t * shake_freq, 0)
    return sign(v) * pow(abs(v), 0.4)

func increase_shake_level(x):
    shake_level = min(1.0, shake_level + x)

func decrease_shake_level(x):
    shake_level = max(0.0, shake_level - x)

func shake():
    var intensity = pow(shake_level, 2)
    var angle = SHAKE_MAX_ANGLE * intensity * perlin(p0, t)
    var offset_x = SHAKE_MAX_OFFSET * intensity * perlin(p1, t)
    var offset_y = SHAKE_MAX_OFFSET * intensity * perlin(p2, t)
    self.offset = Vector2(offset_x, offset_y)
    self.rotation_degrees = angle

func _process(dt):
    t += dt
    shake()
    decrease_shake_level(dt / shake_reset_time)


func _on_game_speed_slider_value_changed(v):
	match_shake_to_game_speed(v)
