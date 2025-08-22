#!/bin/bash

# File paths
USERS_FILE="../data/users-default.txt"
DATA_FILE="../data/data.txt"

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"

# Terminal width
TERM_WIDTH=$(tput cols)
SCREEN_WIDTH=$(( term_width * 70 / 100 ))

# Clear screen and print header
header() {
    clear
    echo -e "\t\t\t\t\t${CYAN}=========================================================================${RESET}"
    echo -e "\t\t\t\t\t\t${CYAN}              GALAXY STAR RECORD SYSTEM        ${RESET}"
    echo -e "\t\t\t\t\t${CYAN}=========================================================================${RESET}"
}

# Login function
login() {
    attempts=0
    while [ $attempts -lt 3 ]; do
        header
        echo -e "${YELLOW}LOGIN${RESET}"
        read -p "Username: " username
        read -s -p "Password: " password
        echo
        if grep -q "^$username|$password$" "$USERS_FILE"; then
            echo -e "${GREEN}Login successful!${RESET}"
            sleep 1
            return 0
        else
            echo -e "${RED}Invalid credentials!${RESET}"
            ((attempts++))
            sleep 1
        fi
    done
    echo -e "${RED}Too many failed attempts. Exiting.${RESET}"
    exit 1
}

# Menu display
menu() {
    header
    echo -e "${YELLOW}[1]${RESET} Add New Star"
    echo -e "${CYAN}[2]${RESET} View All Stars"
    echo -e "${MAGENTA}[3]${RESET} Search Star by Name"
    echo -e "${BLUE}[4]${RESET} Edit Star Info"
    echo -e "${RED}[5]${RESET} Delete Star"
    echo -e "${GREEN}[6]${RESET} Show Distance of a Star"
    echo -e "${WHITE}[7]${RESET} Exit"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -n "Choose an option [1-7]: "
}

# Add a new star
add_star() {
    header
    echo "ADD NEW STAR"
    id=$(($(wc -l < "$DATA_FILE") + 1))
    printf -v id "%03d" $id
    read -p "Star Name: " name
    read -p "Star Type: " type
    read -p "Distance (in km): " distance
    read -p "Short Description: " desc
    echo "$id|$name|$type|$distance|$desc" >> "$DATA_FILE"
    echo -e "${GREEN}Star added successfully!${RESET}"
    read -p "Press Enter to return to menu..."
}

# View all stars
view_stars() {
    header
    echo "ALL STARS RECORDED"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [ -s "$DATA_FILE" ]; then
        sort -t '|' -k1n "$DATA_FILE" | column -s '|' -t
    else
        echo -e "${RED}No records found.${RESET}"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p "Press Enter to return to menu..."
}

# Search star by name
search_star() {
    header
    echo "SEARCH STAR"
    read -p "Enter name: " key
    result=$(grep -i "$key" "$DATA_FILE")
    if [ "$result" ]; then
        echo "Matching Result:"
        echo "$result" | column -s '|' -t
    else
        echo -e "${RED}Star not found!${RESET}"
    fi
    read -p "Press Enter to return to menu..."
}

# Edit star info
edit_star() {
    header
    echo "EDIT STAR INFO"
    read -p "Enter Star ID to edit: " id
    line=$(grep "^$id|" "$DATA_FILE")
    if [ "$line" ]; then
        echo "Old Data:"
        echo "$line" | column -s '|' -t
        grep -v "^$id|" "$DATA_FILE" > temp.txt
        read -p "New Name: " name
        read -p "New Type: " type
        read -p "New Distance (km): " distance
        read -p "New Description: " desc
        echo "$id|$name|$type|$distance|$desc" >> temp.txt
        mv temp.txt "$DATA_FILE"
        echo -e "${GREEN}Star updated successfully!${RESET}"
    else
        echo -e "${RED}Star ID not found!${RESET}"
    fi
    read -p "Press Enter to return to menu..."
}

# Delete star
delete_star() {
    header
    echo "DELETE STAR"
    read -p "Enter Star ID to delete: " id
    if grep -q "^$id|" "$DATA_FILE"; then
        grep -v "^$id|" "$DATA_FILE" > temp.txt && mv temp.txt "$DATA_FILE"
        echo -e "${GREEN}Star deleted successfully!${RESET}"
    else
        echo -e "${RED}Star ID not found!${RESET}"
    fi
    read -p "Press Enter to return to menu..."
}

# Distance check
distance_star() {
    header
    echo "DISTANCE CHECK"
    read -p "Enter Star Name: " name
    match=$(grep -i "$name" "$DATA_FILE")
    if [ "$match" ]; then
        distance=$(echo "$match" | cut -d '|' -f 4)
        echo "Star $name is approximately $distance km away."
    else
        echo -e "${RED}Star not found!${RESET}"
    fi
    read -p "Press Enter to return to menu..."
}

# Main Program
login
while true; do
    menu
    read choice
    case $choice in
        1) add_star ;;
        2) view_stars ;;
        3) search_star ;;
        4) edit_star ;;
        5) delete_star ;;
        6) distance_star ;;
        7) echo "Goodbye, explorer!"; exit ;;
        *) echo -e "${RED}Invalid input${RESET}"; sleep 1 ;;
    esac
done
