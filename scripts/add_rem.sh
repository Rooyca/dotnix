#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory/file>"
  exit 1
fi

target=$1

# Function to open a file with EDITOR
open_with_editor() {
  $EDITOR "$1"
  exit 0
}

# Check if the target is a directory
if [ -d "$target" ]; then
  # List files in the directory
  files=("$target"/*)

  if [ ${#files[@]} -eq 0 ]; then
    echo "No files found in the directory."
    exit 1
  elif [ ${#files[@]} -eq 1 ]; then
    # If there is only one file, open it directly
    open_with_editor "${files[0]}"
  else
    # Display a menu to select a file
    PS3="Select a file to open with EDITOR (press 'q' to exit): "
    select file in "${files[@]}"; do
      if [ -n "$file" ]; then
        open_with_editor "$file"
      elif [ "$REPLY" = "q" ]; then
        echo "Exiting..."
        exit 0
      else
        echo "Invalid selection. Please try again."
      fi
    done
  fi
else
  # Open the target directly with EDITOR
  $EDITOR "$target"
fi