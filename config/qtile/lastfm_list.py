import requests, os
import tkinter as tk

from dotenv import load_dotenv
load_dotenv()

last_fm_api_key = os.getenv('LASTFM_KEY')
user = os.environ.get("USER")

def get_last_fm_scrobbles(api_key, username=user, limit=5):
    url = f'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user={username}&api_key={api_key}&format=json&limit={limit}'
    response = requests.get(url)
    data = response.json()

    if 'recenttracks' in data and 'track' in data['recenttracks']:
        return data['recenttracks']['track']
    else:
        return []

# GUI setup
root = tk.Tk()
root.title("Last.fm Scrobbles")

# Set window size and make it non-resizable
root.geometry("400x130")
root.wm_attributes("-topmost", 1)  # Ensure the window is on top
root.resizable(False, False)  # Make the window non-resizable

# Get the cursor position
cursor_x, cursor_y = root.winfo_pointerxy()

# Calculate the window position
window_x = cursor_x - 200  # Assuming a width of 400, adjust as needed
window_y = cursor_y - 150  # Assuming a height of 300, adjust as needed

# Set the window position
root.geometry(f"+{window_x}+{window_y}")

# Rest of the code remains the same
scrobbles_listbox = tk.Listbox(root, width=50, height=10)
scrobbles_listbox.pack()

def update_scrobbles():
    scrobbles = get_last_fm_scrobbles(api_key=last_fm_api_key, limit=5)

    scrobbles_listbox.delete(0, tk.END)
    for track in scrobbles[1:]:
        track_info = f" ▷ {track['artist']['#text']} - {track['name']}"
        scrobbles_listbox.insert(tk.END, track_info)

update_scrobbles()  # Automatically update scrobbles on startup

root.mainloop()
