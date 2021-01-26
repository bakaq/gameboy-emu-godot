tool

extends Control

var colors = [
	Color(0.7, 0.7, 0.7),
	Color(0.5, 0.5, 0.5),
	Color(0.2, 0.2, 0.2),
]

var screen_rect = Rect2(0, 0, 160, 144)

var screen = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize screen
	for i in range(160*144):
		screen.append(0)

func _draw():
	# Clear screen
	draw_rect(screen_rect, colors[0])
	
	# Draw screen
	for i in range(160):
		for j in range(144):
			draw_pixel(i, j, screen[i + j*144])

func draw_pixel(x, y, color_idx):
	draw_rect(Rect2(x, y, 1, 1), colors[color_idx])
