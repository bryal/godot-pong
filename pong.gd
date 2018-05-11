extends Node2D

export var left_score = 0
export var right_score = 0

onready var camera = get_node("camera")

func give_point(side):
    var score_name = side + "_score"
    var score = self.get(score_name)
    score += 1
    self.set(score_name, score)
    self.get_node(score_name).update_score(score)

func give_point_left():
    give_point("left")

func give_point_right():
    give_point("right")
