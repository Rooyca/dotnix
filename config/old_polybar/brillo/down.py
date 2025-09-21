import os

MIN_BRIGHTNESS = 1000
level = '/home/rooyca/.config/polybar/brillo/level'

with open(level, 'r') as f:
	actual_level = f.read()

new_level = int(actual_level) - 500

if new_level >= MIN_BRIGHTNESS:
	with open(level, 'w') as f:
		f.write(str(new_level))
		os.system(f'echo {new_level} > /sys/class/backlight/intel_backlight/brightness')
	exit()

with open(level, 'w') as f:
	f.write(str(MIN_BRIGHTNESS))
	os.system(f'echo {MIN_BRIGHTNESS} > /sys/class/backlight/intel_backlight/brightness')