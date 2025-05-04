#!/bin/bash

# Check if required arguments exist
if [ $# -lt 2 ]; then
    echo "Error: 2 arguments are required"
    echo "Usage: $0 COMMAND WINDOW_TITLE"
    exit 1
fi

COMMAND="$1"
WINDOW_TITLE="$2"

CLASS="PersistentApp"

# Get window ID if it exists
WINDOW_ID=$(xdotool search --class "$CLASS" 2>/dev/null | head -n 1)
if [ -n "$WINDOW_ID" ]; then
    # Window exists

    # Check if window is visible
    is_visible=$(xdotool search --onlyvisible --class "$CLASS" 2>/dev/null | head -n 1)

    # Get the current active window and desktop
    ACTIVE_WINDOW=$(xdotool getactivewindow)
    CURRENT_DESKTOP=$(xdotool get_desktop)

    if [ "$ACTIVE_WINDOW" = "$WINDOW_ID" ]; then
        # Window is focused - hide it
        xdotool windowunmap "$WINDOW_ID"
    else
        xdotool windowunmap "$WINDOW_ID"
        xdotool set_desktop_for_window "$WINDOW_ID" "$CURRENT_DESKTOP"

        # Map and activate the window on the current desktop
        xdotool windowmap "$WINDOW_ID"
        xdotool windowactivate "$WINDOW_ID"

        # Optional: Raise window to top
        xdotool windowraise "$WINDOW_ID"
    fi
else
    # Launch with class and title for reliable identification
    $COMMAND --class $CLASS --title $WINDOW_TITLE &
fi
