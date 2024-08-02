#!/usr/bin/env python3

import curses
import os
import time

def countdown(stdscr, seconds):
    for remaining in range(seconds, 0, -1):
        stdscr.clear()
        height, width = stdscr.getmaxyx()
        message = f"Countdown: {remaining} seconds"
        x = width // 2 - len(message) // 2
        y = height // 2
        stdscr.addstr(y, x, message)
        stdscr.refresh()
        time.sleep(1)

def main(stdscr):
    # Clear screen
    stdscr.clear()

    # Create a list of options
    options = ["Power Off", "Reboot", "Logout"]
    actions = ["loginctl poweroff", "loginctl reboot", "loginctl terminate-user $USER"]
    try:
        countdown_time = int(os.environ["COUNTDOWN_TIME"])
    except:
        countdown_time = 5

    try:
        while True:
            # Display the options
            stdscr.clear()
            height, width = stdscr.getmaxyx()
            for idx, option in enumerate(options):
                x = width // 2 - len(option) // 2
                y = height // 2 - len(options) // 2 + idx
                stdscr.addstr(y, x, option)

            stdscr.addstr(height // 2 + len(options) // 2 + 1, width // 2 - 10, "Press 'q' to quit")
            stdscr.refresh()

            # Get user input
            key = stdscr.getch()

            # Handle user input
            if key == ord('q'):
                return

            # Map input to action
            if key == ord('s'):
                stdscr.clear()
                countdown(stdscr, countdown_time)
                os.system(actions[0])
            elif key == ord('r'):
                stdscr.clear()
                countdown(stdscr, countdown_time)
                os.system(actions[1])
            elif key == ord('l'):
                stdscr.clear()
                countdown(stdscr, countdown_time)
                os.system(actions[2])
            else:
                continue
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    curses.wrapper(main)