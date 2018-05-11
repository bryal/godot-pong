extends Camera2D

const SHAKE_RESET_TIME = 1.2
const SHAKE_MAX_OFFSET = 25
const SHAKE_MAX_ANGLE = 9 # degrees
const SHAKE_FREQ = 14

var faketime_factor = 1.0
var shake_level = 0.0
var t = 0.0
var p0
var p1
var p2

func _ready():
    var sn = preload("res://SoftNoise/softnoise.gd")
    p0 = sn.SoftNoise.new(0)
    p1 = sn.SoftNoise.new(1)
    p2 = sn.SoftNoise.new(2)

func _process(dt):
    var dt_faketime = dt * self.faketime_factor
    process_faketime(dt_faketime)

func _on_game_speed_slider_value_changed(game_speed):
    self.faketime_factor = pow(2, game_speed)


func process_faketime(dt):
    self.t += dt
    shake(self.t)
    decrease_shake_level(dt / SHAKE_RESET_TIME)

# Perlin noise for the generator `p` at time `t`. Result in range [-1, 1]
func perlin(p, t):
    var v = p.perlin_noise2d(t * SHAKE_FREQ, 0)
    return sign(v) * pow(abs(v), 0.4)

func modify_shake_level(x):
    self.shake_level = clamp(self.shake_level + x, 0.0, 1.0)

func increase_shake_level(x): modify_shake_level(x)
func decrease_shake_level(x): modify_shake_level(-x)

func shake(t):
    var intensity = pow(self.shake_level, 2)
    var angle = SHAKE_MAX_ANGLE * intensity * perlin(self.p0, t)
    var offset_x = SHAKE_MAX_OFFSET * intensity * perlin(self.p1, t)
    var offset_y = SHAKE_MAX_OFFSET * intensity * perlin(self.p2, t)
    self.offset = Vector2(offset_x, offset_y)
    self.rotation_degrees = angle
