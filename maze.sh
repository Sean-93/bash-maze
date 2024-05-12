#!/bin/bash

# Define a very large and complex map as an array of strings
map=(
    "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
    "|     |             |           |           |       |"
    "| ||| | ||||| | ||| | ||||||| ||| ||||||| ||| ||||| |"
    "| | | | |     |   | | |     |     | |     |     |   |"
    "| | ||| | ||||| ||| | | | | ||||| | | ||| ||||||| | |"
    "|       |     |     |   | |     | | | | | |     | | |"
    "||| ||||| ||||| ||||||||| ||||| | | | | | | ||| | | |"
    "|   |     |   |     |     |   | | |   | | | |   | | |"
    "| | | ||||| ||| ||| | ||| | | | | ||||| | | ||| ||| |"
    "| | |     |     |   |   | | | | |       | |   |     |"
    "| | ||||| | ||| ||||| ||| | | | | ||||| | | ||||| |||"
    "| |     | | | | |     |   | | | | |     | |     |   |"
    "| ||||| | | | | | ||| | ||||| | | | ||| | | ||||| |||"
    "|     | | | | | | |   |     | | | |   | |       |   x"
    "||||| | | | | | | | ||||||| | | | | | | ||| | ||||  |"
    "|   | | | | | | | | |     | | |   | | |     |     | |"
    "| | | | | | | | ||| | ||| | | ||||| | | ||| ||||||| |"
    "| | | | | | | |     |   | | |     | | |   |       | |"
    "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
)

# Initial player position and direction
player_x=1
player_y=1
player_icon="→"  # Default starting icon (right arrow)

# Clear the screen initially
clear

# Function to draw the map with the player's position
draw_map() {
    echo -ne "\033[H"  # Move cursor to the top-left corner.
    for y in "${!map[@]}"; do
        if [[ $y -eq $player_y ]]; then
            echo "${map[$y]:0:$player_x}$player_icon${map[$y]:$player_x+1}"
        else
            echo "${map[$y]}"
        fi
    done
    echo "Position: ($player_x, $player_y) Facing: $player_icon"
}

# Function to update player position and icon
move_player() {
    local new_x=$player_x
    local new_y=$player_y

    case $1 in
        w) (( new_y-- )); player_icon="↑" ;;
        s) (( new_y++ )); player_icon="↓" ;;
        a) (( new_x-- )); player_icon="←" ;;
        d) (( new_x++ )); player_icon="→" ;;
    esac

    # Check for wall and boundaries
    if [[ ${map[new_y]:new_x:1} != "|" ]] && [[ new_x -ge 0 ]] && [[ new_x -lt ${#map[0]} ]] && [[ new_y -ge 0 ]] && [[ new_y -lt ${#map[@]} ]]; then
        player_x=$new_x
        player_y=$new_y
    fi
}

# Check if the player reached the exit
check_exit() {
    if [[ ${map[player_y]:player_x:1} == "x" ]]; then
        clear
        echo "You've escaped the maze! Game over! Start again? (y/n)"
        read -n 1 -s answer
        if [[ $answer == "y" || $answer == "Y" ]]; then
            exec "$0"  # Restart the script
        else
            echo "Thanks for playing!"
            exit 0
        fi
    fi
}

# Main game loop
while true; do
    draw_map
    read -n 1 -s key
    move_player $key
    check_exit
done
