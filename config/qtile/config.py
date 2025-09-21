import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from dotenv import load_dotenv
load_dotenv()

mod = "mod4"
terminal = "kitty"
user = os.environ.get("USER")
lastfm_key = os.getenv("LASTFM_KEY")

# If your terminal is alacritty/kitty or has support for options --hold and -e (which is unlikely) don't change it here.
# Otherwise go and change these widgets one by one to work with your terminal:
# CPU
# Memory
# Net
# Clock - using gsimplecal, remember to have custom config, in order to open below date and time

## Keybindings - Custom keybindings
keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "space", lazy.layout.next()),

    # Controls for Max layout ("<" and ">" arrows) to change focus windows
    Key([mod], "Left", lazy.layout.up().when(layout="max")),
    Key([mod], "Right", lazy.layout.down().when(layout="max")),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod], "n", lazy.layout.normalize()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod, "control", "shift"], "q", lazy.shutdown()),
    Key([mod, "control", "shift"], "p", lazy.spawn(".local/bin/pmanager")),

    ## CUSTOM
    # Toggle fullscreen
    Key([mod], "f",  lazy.window.toggle_fullscreen()),

    # Lock
    Key([mod], "x", lazy.spawn("physlock -s -p ' == Who is you =='")),

    # Spawn apps
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "e", lazy.spawn("pcmanfm")),
    Key([mod], "b", lazy.spawn("brave")),
    # Run "rofi-theme-selector" in terminal to select a theme
    Key([mod], "s", lazy.spawn("rofi -show drun")),

    # Screenshot
    Key([], "Print", lazy.spawn("flameshot gui")),

    # Use volume, audio and brigthness controls on your keyboard
    # Volume
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    # Audio controls
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    #([], "XF86AudioPause", lazy.spawn("playerctl play-pause")),    # just in case

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
]

## Colors
colors = [
    ["#292d3e", "#292d3e"],  # 0 - panel background
    ["#434758", "#434758"],  # 1 - lighter background
    ["#ffffff", "#ffffff"],  # 2 - white - font color for group names
    ["#464cd6", "#464cd6"],  # 3 - blue darker
    ["#8d62a9", "#8d62a9"],  # 4 - purple normal - color for other tab and odd widgets
    ["#668bd7", "#668bd7"],  # 5 - blue
    ["#e1acff", "#e1acff"],  # 6 - pink
    ["#000000", "#000000"],  # 7 - black
    ["#AD343E", "#AD343E"],  # 8 - red
    ["#db5d4d", "#db5d4d"],  # 9 - orange - current tab color
    ["#DA8C10", "#DA8C10"],  # 10 - yellow/gold
    ["#F7DC6F", "#F7DC6F"],  # 11 - yellow bright
    ["#f1ffff", "#f1ffff"],  # 12 - almost white
    ["#4c566a", "#4c566a"],  # 13 - greyish
    ["#387741", "#387741"],  # 14 - green
    ["#5f3f87", "#5f3f87"],  # 15 - purple
]

## Groups - Workspaces, tags or desktops (call them what you want),
## Open brave in first group, Sublime in second and pcmanfm in third
groups = [
    Group("1",
        label="⏺",
        matches=[
            Match(wm_class=["Brave-browser"]),
            Match(wm_class=["qutebrowser"]),
        ],
    ),
    Group("2",
        label="⏺",
        matches=[Match(wm_class=["Subl"])],
    ),
    Group("3",
        label="⏺",
        matches=[Match(wm_class=["pcmanfm"])],
    ),
    Group("4",
        label="⏺",
        #matches=[Match(wm_class=[])],
    ),
]

# Magic behind groups
for i in groups:
    keys.extend([
            # mod1 + letter of group = switch to group
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False))
        ]
    )

## Function to process lastfm data
# def process_data(response_data):
#     title = response_data['recenttracks']['track'][0]['name']
#     artist = response_data['recenttracks']['track'][0]['artist']['#text']
#     artist = artist.replace('&', 'and')
#     title = title.replace('&', 'and')
#     return f" ▶️ {artist} - {title[:8]+'...' if len(title) > 8 else title}"

## Layouts - Max as main, floating as layout not floating rules to windows
layouts = [
            layout.Max(),
            layout.Columns(
                border_focus=colors[6],
                border_normal=colors[1],
                border_on_single=False,
                fair=True,
            ),
            # In order to change aspects of floating windows in other layouts,
            # see floating_layout at the Advanced section at the bottom
            layout.floating.Floating(
                border_focus=colors[6],
                border_normal=colors[1],
            ),
            layout.TreeTab(
                font="AnonymicePro Nerd Font",
                fontsize=15,
                border_width=2,
                bg_color=colors[0],
                active_bg=colors[9],
                active_fg=colors[12],
                inactive_bg=colors[1],
                inactive_fg=colors[12],
                padding_left=0,
                panel_width=175,
                vspace=2,
            ),
            layout.RatioTile(
                border_focus=colors[6],
                border_normal=colors[1],
            ),
]

## Screens
screens = [
    Screen(
        top=bar.Bar([
            # widget.CurrentLayoutIcon(
            #     foreground=colors[0],
            #     background=colors[0],
            #     padding=1,
            #     scale=0.6,
            # ),
            widget.Image(
                filename="~/.config/qtile/icons/arch.png",
                scale=True,
                margin=2,
                background=colors[0],
                mouse_callbacks={'Button1': lazy.spawn(".local/bin/pmanager")},
            ),
            widget.GroupBox(
                fontsize=11,
                margin_y=4,
                margin_x=2,
                padding_y=5,
                padding_x=1,
                borderwidth=3,
                active=colors[2],
                inactive=colors[1],
                rounded=True,
                highlight_method='block',
                urgent_alert_method='text',
                this_current_screen_border=colors[4],
                this_screen_border=colors[4],
                other_current_screen_border=colors[0],
                other_screen_border=colors[0],
                foreground=colors[2],
                background=colors[0],
                disable_drag=True,
                hide_unused=False,
            ),
            widget.Sep(
                linewidth=0,
                padding=3,
                foreground=colors[2],
                background=colors[0],
            ),
            widget.TaskList(
                theme_path="/usr/share/icons/Papirus/index.theme",
                theme_mode="preferred",
                highlight_method = 'block',
                icon_size=12,
                max_title_width=60,
                rounded=True,
                margin=0,
                padding=3,
                fontsize=10,
                border=colors[4],
                foreground=colors[2],
                borderwidth = 0,
                background=colors[0],
                urgent_border=colors[5],
                txt_floating='🗗 ',
                txt_minimized='_ ',
            ),
            widget.Spacer(
                width=bar.STRETCH,
                background=colors[0],
            ),
            widget.Clock(
                foreground=colors[2],
                background=colors[0],
                padding=4,
                format=" <b>%b %d (%a) %I:%M %p</b> ",
                mouse_callbacks={'Button1': lazy.spawn("gsimplecal")},
            ),
            widget.GenPollCommand(
                cmd="~/.scripts/reminders.sh",
                background=colors[0],
                shell=True,
                fontsize=12,
                padding=0,
                fontshadow=colors[1],
                mouse_callbacks={'Button1': lazy.spawn(terminal+" --hold -e remind -s .reminders/primary.rem")},
            ),
            widget.Spacer(
                width=bar.STRETCH,
                background=colors[0],
            ),
            widget.WidgetBox(widgets=[
                # widget.GenPollUrl(
                #     url=f"https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user={user}&api_key={lastfm_key}&format=json",
                #     parse=process_data,
                #     update_interval=60,
                #     json=True,
                #     background=colors[15],
                #     mouse_callbacks={'Button1': lazy.spawn(terminal + " python .config/qtile/lastfm_list.py")},
                #     user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0",
                # ),
                widget.Memory(
                    foreground=colors[2],
                    background=colors[4],
                    format=" 🧠 {MemPercent: .0f}% ",
                    mouse_callbacks={
                        'Button1': lazy.spawn(terminal + " --hold -e htop"),                    # left click
                        'Button3': lazy.spawn(terminal + " --hold -e watch -n 2 free -th"),     # right click
                    },
                ),
                widget.CPU(
                    foreground=colors[2],
                    background=colors[15],
                    format=" 🔲 {load_percent: .0f}% ",
                    mouse_callbacks={'Button1': lazy.spawn(terminal + " --hold -e watch -n 2 sensors")},
                ),
                widget.Volume(
                    background=colors[4],
                    emoji=False,
                    fontsize=12,
                    emoji_list= ['󰖁', '󰕿', '󰖀', '󰕾'],
                    mouse_callbacks={'Button3': lazy.spawn("pavucontrol")},
                    fmt=" 📢 {} ",
                ),
                widget.Backlight(
                    backlight_name='intel_backlight',
                    background=colors[15],
                    format=' 🔆 {percent:2.0%} ',
                ),
                # widget.GenPollCommand(
                #     cmd="~/.config/qtile/wifi.sh",
                #     shell=True,
                #     update_interval=10,
                #     background=colors[15],
                #     fmt=" {} ",
                #     mouse_callbacks={'Button1': lazy.spawn("nm-connection-editor")},

                # ),
                # widget.GenPollCommand(
                #     cmd="nb todos open | wc -l",
                #     foreground=colors[2],
                #     background=colors[15],
                #     shell=True,
                #     fmt=" 📝 {} ",
                # ),
            ],
            background=colors[15],
            text_open="CLOSE",
            text_closed="SHOW",
            fmt=" <b>{}</b> ",
            fontsize=12,
            ),
            widget.Battery(
                foreground=colors[2],
                background=colors[4],
                format=" 🔋 {percent:2.0%} ",
                update_interval=30,
                show_short_text=False,
                notify_below=20,
                notification_timeout=0,
                low_background=colors[8],
                low_foreground=colors[0],
            ),
            widget.Net(
                format='↓{down:.0f}{down_suffix} ↑{up:.0f}{up_suffix}',
                background=colors[15],
                #prefix='M',
            ),
            widget.Systray(
                background=colors[15],
                icon_size=18,
            ),
            # widget.CheckUpdates(
            #     execute="alacritty -e sudo pacman -Syu",
            #     background=colors[4],
            #     foreground=colors[3],
            #     colour_no_updates=colors[2],
            #     colour_have_updates=colors[12],
            #     padding=5,
            #     no_update_string='🟢',
            #     mouse_callbacks={'Button1': lazy.spawn("alacritty -e sudo pacman -Syu")},
            # ),
            # widget.LaunchBar(
            #     progs=[
            #         ("", "reboot", "reboot"),
            #         ("", f"loginctl terminate-user {user}", "logout"),
            #         ("", "shutdown -h 0", "shutdown"),
            #     ],
            #     background=colors[4],
            #     padding=5,
            #     fontsize=13,
            # ),
            ], 20,
            opacity=0.9,
        ),
    ),
]


# Mouse
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
     start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
     start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

## Autostart (start only once - on boot)
@hook.subscribe.startup_once
def autostart():
    home=os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

## Advanced
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    # Change aspects of floating windows in every layout
    border_width=1,
    border_focus=colors[6],
    border_normal=colors[7],
)

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
