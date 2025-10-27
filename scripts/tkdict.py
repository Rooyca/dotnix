#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3
import tkinter as tk
from tkinter import ttk

import nltk
from nltk.corpus import wordnet

import requests
import json
import os

API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
SAVED_WORDS_FILE = os.path.join(os.path.expanduser("~"), ".tkdict_saved_words.json")

def get_api_definition(word):
    """Fetch definition from online API"""
    try:
        response = requests.get(API_URL + word, timeout=5)
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, list) and data:
                return data[0]  # Return first result
        return None
    except Exception as e:
        print(f"API error: {e}")
        return None

###
### RUN THIS IF IS THE FIRST TIME YOU USE THE APP
###
def setup_wordnet():
    """One-time setup - download WordNet data"""
    try:
        nltk.download('wordnet', quiet=True)
        nltk.download('omw-1.4', quiet=True)
        return True
    except:
        return False

def get_wordnet_definition(word):
    """Get definition from WordNet offline database"""
    try:
        synsets = wordnet.synsets(word)
        if not synsets:
            return None
        
        # Group by part of speech
        pos_groups = {}
        for syn in synsets:
            pos = syn.pos()
            if pos == 'n': pos_name = 'noun'
            elif pos == 'v': pos_name = 'verb'
            elif pos == 'a': pos_name = 'adjective'
            elif pos == 'r': pos_name = 'adverb'
            elif pos == 's': pos_name = 'adjective satellite'
            else: pos_name = pos
            
            if pos_name not in pos_groups:
                pos_groups[pos_name] = []
            
            pos_groups[pos_name].append({
                'definition': syn.definition(),
                'example': syn.examples()[0] if syn.examples() else None
            })
        
        # Format similar to API response
        meanings = []
        for pos, definitions in pos_groups.items():
            meanings.append({
                'partOfSpeech': pos,
                'definitions': definitions[:3]  # Limit to 3 definitions per POS
            })
        
        return {
            'word': word,
            'meanings': meanings
        }
        
    except Exception as e:
        print(f"WordNet error: {e}")
        return None

class DictionaryApp:
    def __init__(self, root):
        self.root = root
        self.saved_words = self.load_saved_words()
        self.output = None  # Will be created when needed
        self.text_frame = None  # Keep reference to text frame
        self.setup_gui()

    def setup_gui(self):
        self.root.title("Dictionary")
        self.root.configure(bg='#2c2c2c')  # Dark background
        
        # Configure dark theme for scrollbars
        self.setup_dark_scrollbar_style()
        
        # Start with smaller window size (just for search bar)
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        x_position = (screen_width - 600) // 2
        y_position = (screen_height - 90) // 2  # Smaller without button
        self.root.geometry(f"600x90+{x_position}+{y_position}")
        self.root.wm_attributes("-topmost", 1)
        self.root.resizable(False, False)

        # Create frame for search bar with icon
        search_frame = tk.Frame(self.root, bg='#2c2c2c')
        search_frame.pack(fill=tk.X, padx=20, pady=20)
        
        # Search icon (using Unicode)
        search_icon = tk.Label(search_frame, 
                              text=" 🔍", 
                              font=("Segoe UI", 14),
                              bg='#3d3d3d',
                              fg='#695882',
                              width=2,
                              relief='flat',
                              bd=1)
        search_icon.pack(side=tk.LEFT, fill=tk.Y)

        # Entry with Ctrl+Backspace support
        self.entry = tk.Entry(search_frame, 
                             font=("Segoe UI", 14), 
                             relief='flat',
                             bd=1,
                             highlightthickness=2,
                             highlightcolor='#695882',
                             highlightbackground='#3d3d3d',
                             bg='#3d3d3d',
                             fg='#e8e8e8',
                             insertbackground='#695882')
        self.entry.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.entry.focus()
        self.entry.bind('<Control-BackSpace>', self.delete_word)
        self.entry.bind('<Control-w>', self.delete_word)  # Alternative binding

        # Bind events
        self.root.bind("<Return>", lambda event: self.lookup_word())
        self.root.bind("<Control-l>", lambda event: self.clear_and_hide())
        self.root.bind("<Control-L>", lambda event: self.clear_and_hide())  # Capital L too

    def setup_dark_scrollbar_style(self):
        """Configure dark theme for scrollbars"""
        style = ttk.Style()
        
        # Configure scrollbar colors for dark theme
        style.theme_use('clam')
        
        style.configure("Vertical.TScrollbar",
                       background='#3d3d3d',
                       troughcolor='#2c2c2c',
                       bordercolor='#3d3d3d',
                       arrowcolor='#695882',
                       darkcolor='#3d3d3d',
                       lightcolor='#3d3d3d')
        
        style.map("Vertical.TScrollbar",
                 background=[('active', '#695882'),
                            ('pressed', '#5a4a72')])

        style.configure("Horizontal.TScrollbar",
                       background='#3d3d3d',
                       troughcolor='#2c2c2c',
                       bordercolor='#3d3d3d',
                       arrowcolor='#695882',
                       darkcolor='#3d3d3d',
                       lightcolor='#3d3d3d')
        
        style.map("Horizontal.TScrollbar",
                 background=[('active', '#695882'),
                            ('pressed', '#5a4a72')])

    def create_output_widget(self):
        """Create the output widget when needed"""
        if self.output is None:
            # Resize window to accommodate the output
            screen_width = self.root.winfo_screenwidth()
            screen_height = self.root.winfo_screenheight()
            x_position = (screen_width - 600) // 2
            y_position = (screen_height - 420) // 2  # Slightly taller
            self.root.geometry(f"600x420+{x_position}+{y_position}")
            
            # Create text widget with custom scrollbar
            self.text_frame = tk.Frame(self.root, bg='#2c2c2c')
            self.text_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=(0, 20))
            
            # Text widget
            self.output = tk.Text(self.text_frame,
                                 wrap=tk.WORD, 
                                 font=("Georgia", 11),
                                 relief='flat',
                                 bd=1,
                                 highlightthickness=1,
                                 highlightcolor='#3d3d3d',
                                 highlightbackground='#3d3d3d',
                                 bg='#3d3d3d',
                                 fg='#e8e8e8',
                                 selectbackground='#695882',
                                 selectforeground='#ffffff')
            
            # Custom dark scrollbar
            scrollbar = ttk.Scrollbar(self.text_frame, orient="vertical", command=self.output.yview)
            self.output.configure(yscrollcommand=scrollbar.set)
            
            # Pack text and scrollbar
            self.output.pack(side="left", fill="both", expand=True)
            scrollbar.pack(side="right", fill="y")

            # Configure text tags for better formatting
            self.output.tag_configure("title", font=("Segoe UI", 18, "bold"), foreground="#e8e8e8")
            self.output.tag_configure("phonetic", font=("Georgia", 12, "italic"), foreground="#a8a8a8")
            self.output.tag_configure("pos", font=("Segoe UI", 12, "bold"), foreground="#695882")
            self.output.tag_configure("definition", font=("Georgia", 11), lmargin1=20, lmargin2=20, foreground="#d0d0d0")
            self.output.tag_configure("example", font=("Georgia", 10, "italic"),
                                     foreground="#9fb584", lmargin1=40, lmargin2=40)

    def hide_output_widget(self):
        """Hide and destroy the output widget"""
        if self.text_frame is not None:
            self.text_frame.destroy()
            self.text_frame = None
            self.output = None
            
            # Resize window back to small size
            screen_width = self.root.winfo_screenwidth()
            screen_height = self.root.winfo_screenheight()
            x_position = (screen_width - 600) // 2
            y_position = (screen_height - 120) // 2
            self.root.geometry(f"600x85+{x_position}+{y_position}")

    def clear_and_hide(self):
        """Clear search entry and hide output widget (Ctrl+L)"""
        self.entry.delete(0, tk.END)
        self.hide_output_widget()
        self.entry.focus()

    def delete_word(self, event):
        """Delete word at cursor position when Ctrl+Backspace is pressed"""
        cursor_pos = self.entry.index(tk.INSERT)
        text = self.entry.get()

        # Find start of current word
        start = cursor_pos
        while start > 0 and text[start - 1] not in ' \t\n':
            start -= 1

        # Delete the word
        self.entry.delete(start, cursor_pos)
        return "break"  # Prevent default behavior

    def lookup_word(self):
        word = self.entry.get().strip().lower()
        if not word:
            return

        self.create_output_widget()

        # Check if word is saved locally
        if word in self.saved_words:
            self._display_definition(self.saved_words[word])
            return

        # First, try online API lookup
        api_result = get_api_definition(word)
        if api_result:
            self._display_definition(api_result)
            self._save_word(word, api_result)
            return

        # If API fails, fallback to offline WordNet lookup
        wordnet_result = get_wordnet_definition(word)
        if wordnet_result:
            self._display_definition(wordnet_result)
            self._save_word(word, wordnet_result)
            return

        # If not found anywhere
        self.output.delete('1.0', tk.END)
        self.output.insert(tk.END, f"No definition found for '{word}'.")

    def _display_definition(self, data):
        if self.output is None:
            return

        self.output.delete('1.0', tk.END)

        # Handle both API and WordNet formats
        word = data.get('word', '').title()
        self.output.insert(tk.END, f"{word}\n", "title")

        phonetics = data.get("phonetics", [])
        phonetic_text = ""
        if phonetics:
            phonetic_text = phonetics[0].get("text", data.get("phonetic", ""))
        elif data.get("phonetic"):
            phonetic_text = data.get("phonetic")

        if phonetic_text:
            self.output.insert(tk.END, f"{phonetic_text}\n\n", "phonetic")
        else:
            self.output.insert(tk.END, "\n")

        meanings = data.get("meanings", [])
        for i, meaning in enumerate(meanings):
            part_of_speech = meaning.get("partOfSpeech", "").upper()
            self.output.insert(tk.END, f"{part_of_speech}\n", "pos")

            definitions = meaning.get("definitions", [])
            for j, definition in enumerate(definitions, 1):
                def_text = definition.get('definition', '')
                self.output.insert(tk.END, f"{j}. {def_text}\n", "definition")

                example = definition.get("example")
                if example:
                    self.output.insert(tk.END, f'   Example: "{example}"\n', "example")

                self.output.insert(tk.END, "\n")

            if i < len(meanings) - 1:
                self.output.insert(tk.END, "─" * 40 + "\n\n")


    def _save_word(self, word, data):
        """Save word definition locally"""
        self.saved_words[word] = data
        try:
            with open(SAVED_WORDS_FILE, 'w', encoding='utf-8') as f:
                json.dump(self.saved_words, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"Error saving word: {e}")

    def load_saved_words(self):
        """Load previously saved words"""
        try:
            if os.path.exists(SAVED_WORDS_FILE):
                with open(SAVED_WORDS_FILE, 'r', encoding='utf-8') as f:
                    return json.load(f)
        except Exception as e:
            print(f"Error loading saved words: {e}")
        return {}

def main():
    #setup_wordnet()  # Uncomment this line if you need to download WordNet data
    root = tk.Tk()
    app = DictionaryApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()