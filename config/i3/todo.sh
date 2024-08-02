#!/bin/bash

export PATH="$PATH:/home/rooyca/.local/bin/todo"

todo_output=$(t ls -s ANY --sort "percent_complete")  # Run the 'todo' command and capture its output
line_count=$(echo "$todo_output" | wc -l)  # Count the lines in the output

echo "$line_count"

