# starts the window manager (bspwm in this case)
exec bspwm

# restores the last colorscheme that was in use
wal -R

# restarts mpd
mpd

# lockscreen
betterlockscreen -l blur

# reset the mouse cursor - patch
xsetroot -cursor_name left_ptr

# dunst notifications daemon mpd event listener
dunst_mpdlisten &
