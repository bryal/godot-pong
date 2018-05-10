# Easing functions

class Constant:
    var h
    func _init(h):
        self.h = h
    func step(dt):
        return h

# f(t) = -at^2 + h
class BounceParabola:
    var t_end
    var t
    var h
    var a

    func _init(height, time):
        var halftime = float(time) / 2.0
        self.t_end = halftime
        self.t = -halftime
        self.h = height
        self.a = float(height) / pow(halftime, 2.0)

    func step(dt):
        if t > t_end || t + dt > t_end:
            return 0.0
        else:
            t += dt
            return -a * pow(t, 2.0) + h

class DampenedSine:
    var t = 0.0
    var t_end
    var decay
    var amp
    var f

    func _init(amplitude, freq, time):
        self.amp = float(amplitude)
        self.t_end = time
        self.decay = 2.1 / float(time)
        self.f = float(freq)

    func step(dt):
        if (t + dt) > (t_end * 1.3):
            return 0.0
        else:
            t += dt
            return amp * exp(-decay * t) * sin(f * 2 * PI * t)

func new_constant(h):
    return Constant.new(h)

func new_bounce_parabola(height, time):
    return BounceParabola.new(height, time)

func new_dampened_sine(amp, freq, time):
    return DampenedSine.new(amp, freq, time)
