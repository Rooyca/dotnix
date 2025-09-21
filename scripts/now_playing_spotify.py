#!/usr/bin/env python3

import requests, os, time, json
from dotenv import load_dotenv
load_dotenv()

last_fm_api_key = os.getenv('LASTFM_KEY')
user = os.environ.get("USER")

PATH = os.path.expanduser("~/.scripts")
LOCAL_PLAYER = "strawberry"
DEFAULT_SLEEP_TIME = 10

# change the cwd to $HOME/.scripts
os.chdir(PATH)

def get_last_fm_scrobbles(api_key, username=user, limit=1):
    url = f'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user={username}&api_key={api_key}&format=json&limit={limit}'
    response = requests.get(url)
    data = response.json()

    if 'recenttracks' in data and 'track' in data['recenttracks']:
        return data['recenttracks']['track']
    return []

def get_last_fm_track_info():
    scrobbles = get_last_fm_scrobbles(api_key=last_fm_api_key, limit=1)
    response = {}
    if scrobbles:
        track = scrobbles[0]
        artist = track['artist']['#text']
        song = track['name']
        img = track['image'][1]['#text']
        # check if the track is currently playing
        if '@attr' in track and 'nowplaying' in track['@attr']:
            response = {
                'artist': artist,
                'song': song,
                'img': img
            }

    return response

def download_image(url, file_path):
    response = requests.get(url)
    if response.status_code == 200:
        with open(file_path, 'wb') as file:
            file.write(response.content)
        return file_path
    return None

if __name__ == '__main__':
    try:
        while True:
            # check if your local music player is running
            if not os.system(f"pgrep {LOCAL_PLAYER} > /dev/null"):
                time.sleep(DEFAULT_SLEEP_TIME)
                continue

            current_song = get_last_fm_track_info()
            if not current_song:
                time.sleep(DEFAULT_SLEEP_TIME)
                continue

            # if lastplayed file does not exist, create it
            if not os.path.exists("lastplayed.json"):
                with open("lastplayed.json", "w") as f:
                    f.write('{"artist": "", "song": "", "img": ""}')
            # read lastplayed.json
            with open("lastplayed.json", "r") as f:
                lastplayed = f.read()
            lastplayed = json.loads(lastplayed)
            
            # if current song is different from last played song
            if current_song != lastplayed:
                # Update lastplayed.json
                with open("lastplayed.json", "w") as f:
                    f.write(json.dumps(current_song))
                
                # Download the image if it's different
                image_path = "lastfm.png"
                if current_song['img'] != lastplayed['img']:
                    download_image(current_song['img'], image_path)
                
                # Send the notification
                os.system(f"notify-send -i {PATH}/{image_path} '{current_song['artist']} - {current_song['song']}'")
            
            time.sleep(DEFAULT_SLEEP_TIME)
    except KeyboardInterrupt:
        print("[!] Exiting...")