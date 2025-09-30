if status is-login
    if test (tty) = "/dev/tty1"
        export QT_QPA_PLATFORMTHEME="qt6ct"
        if test "$SESSION" = "x11"
            exec dbus-run-session startx -- -keeptty
        else if test "$SESSION" = "wayland"
            export XKB_DEFAULT_LAYOUT=es
            exec dbus-run-session sway
        end
    end
end


