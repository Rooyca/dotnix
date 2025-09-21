#!/usr/bin/python3

import os

def read_radios(filepath):
    radios = []
    try:
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    try:
                        name, url = line.split('=', 1)
                        radios.append((name.strip(), url.strip()))
                    except ValueError:
                        print(f"Warning: Skipping invalid line: {line}")
    except FileNotFoundError:
        print(f"Error: File not found: {filepath}")
    return radios

def generate_aliases(radios):
    aliases = []
    for name, url in radios:
        url = f'"{url}"'
        alias = f"alias p{name}='mpc clear && mpc add {url} && mpc play'"
        aliases.append(alias)
    return aliases

def main():
    dotfile = os.path.expanduser('~/.radios.ry')
    radios = read_radios(dotfile)
    aliases = generate_aliases(radios)
    
    # Print aliases to stdout
    if aliases:
        for alias in aliases:
            print(alias)
    else:
        print("No valid radio entries found.")

if __name__ == "__main__":
    main()
