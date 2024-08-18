import os

MAX_BRIGHTNESS = 6000
level = '/home/rooyca/.config/polybar/brillo/level'

with open(level, 'r') as f:
	actual_level = f.read()

new_level = int(actual_level) + 500

if new_level <= MAX_BRIGHTNESS:
	with open(level, 'w') as f:
		f.write(str(new_level))
		os.system(f'echo {new_level} > /sys/class/backlight/intel_backlight/brightness')
	exit()

with open(level, 'w') as f:
	f.write(str(MAX_BRIGHTNESS))
	os.system(f'echo {MAX_BRIGHTNESS} > /sys/class/backlight/intel_backlight/brightness')