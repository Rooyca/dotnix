MAX_BRIGHTNESS = 6000
level = '/home/rooyca/.config/polybar/brillo/level'

with open(level, 'r') as f:
	actual_level = f.read()

porcentage = round((int(actual_level) * 100) / MAX_BRIGHTNESS)

print(str(porcentage)+'%')