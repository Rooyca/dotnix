#!/usr/bin/env python3
"""

- Tag Extraction: Uses regular expressions to find tags in markdown files and skips HTML code blocks.
- Tag Selection: Displays tags sorted by occurrence count using fzf.
- File Preview: Allows the user to select a file containing the selected tag with a preview using cat.
- Editor Variable: Uses the EDITOR env to open the selected file (use cat if EDITOR is not set).

"""

import os
import re
import subprocess
import time

NOTEBOOK = "acustic"

# Change working directory to $HOME/.nb/NOTEBOOK
home_directory = os.path.expanduser("~")
work_directory = os.path.join(home_directory, ".nb", NOTEBOOK)
os.chdir(work_directory)

# Step 1: Use Python re to get the list of tags and their occurrences
tags_dict = {}
markdown_files = [f for f in os.listdir(work_directory) if f.endswith('.md')]

tag_pattern = re.compile(r'#[\w.-]{2,}')

beggining = time.time()

for filename in markdown_files:
    with open(filename, 'r', encoding='utf-8', errors='ignore') as file:
        content = file.read()
        # Remove HTML code blocks
        content = re.sub(r'```html.*?```', '', content, flags=re.DOTALL)
        tags = tag_pattern.findall(content)
        for tag in tags:
            if tag not in tags_dict:
                tags_dict[tag] = []
            tags_dict[tag].append(filename)

print(f"Time elapsed: {time.time() - beggining}")

# Step 2: Prepare the tags for fzf, sorted by occurrence count
tags_list = sorted(
    [f"{tag} ({len(files)} occurrences)" for tag, files in tags_dict.items()],
    key=lambda x: int(re.search(r'\((\d+) occurrences\)', x).group(1)),
    reverse=True
)

# Step 3: Use fzf to select a tag
fzf_process = subprocess.run(['fzf'], input='\n'.join(tags_list), text=True, capture_output=True)
if not fzf_process.stdout.strip():
    exit(0)

selected_tag = fzf_process.stdout.strip().split()[0]  # Extract the tag from the selected line

# Step 4: Show the files containing the selected tag in a new fzf with preview
files_list = tags_dict[selected_tag]
fzf_files_process = subprocess.run(
    ['fzf', '--preview', 'cat {}'],
    input='\n'.join(files_list),
    text=True,
    capture_output=True
)

selected_file = fzf_files_process.stdout.strip()
if selected_file:
    editor = os.getenv('EDITOR', 'cat')
    subprocess.run([editor, selected_file])