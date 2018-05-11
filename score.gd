extends Label

const EASING = preload("res://easing.gd")

const WHITE = Color(1, 1, 1)
const FLASH_STRENGTH = 1.0
const FLASH_TIME = 0.4
const FLASH_COLOR = Color(1.0, 1.0, 0.3)

var flasher = EASING.new_constant(0)

func _process(dt):
    step_flasher(dt)

func step_flasher(dt):
    var strength = self.flasher.step(dt)
    self.set("custom_colors/font_color", WHITE.linear_interpolate(FLASH_COLOR, strength))
    var s = 1 + strength / 2.0
    self.rect_scale = Vector2(s, s)

func set_score_flasher():
    self.flasher = EASING.new_bounce_parabola(FLASH_STRENGTH, FLASH_TIME)

func update_score(points):
    self.text = str(points)
    self.set_score_flasher()
