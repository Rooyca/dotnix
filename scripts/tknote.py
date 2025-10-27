#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import tkinter as tk
from tkinter import messagebox
from datetime import datetime
import subprocess

# Define global variable for the current note file
current_file = None

# Save the current note to the current file
def save_note():
    global current_file
    if current_file:
        text = text_area.get("1.0", tk.END)
        try:
            if (len(text) > 1):
                with open(current_file, "w") as file:
                    file.write(text)
            #messagebox.showinfo("Success", f"Saved as {current_file}!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to save note: {e}")

def clear_note():
    text_area.delete("1.0", tk.END)

def on_close():
    save_note()  # Save note when exiting
    root.destroy()

# Create the main application window
root = tk.Tk()

screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x_position = (screen_width - 600) // 2
y_position = (screen_height - 400) // 2

root.title("quicknote - nb")
root.geometry(f"600x400+{x_position}+{y_position}")

root.wm_attributes("-topmost", 1)
root.resizable(False, False)

# Create a new note file with the current date and time
now = datetime.now().strftime("%Y%m%d%H%M%S")
result = subprocess.run('cat ~/.config/tknote', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

if result.returncode == 0:
    current_file = result.stdout.strip() + f"/{now}.md"
else:
    messagebox.showerror("Error", f"Failed. Check if you have NB installed.")
    exit(1)

# Create a text area for note editing
text_area = tk.Text(root, undo=True, wrap=tk.WORD, font=("Arial", 12))
text_area.pack(expand=True, fill=tk.BOTH, padx=5, pady=5)

# Focus the text area
text_area.focus_set()

# Add keyboard shortcuts
root.bind("<Control-s>", lambda event: save_note())
root.bind("<Control-d>", lambda event: clear_note())

# Set the close event handler
root.protocol("WM_DELETE_WINDOW", on_close)

# Start the application's main event loop
root.mainloop()
