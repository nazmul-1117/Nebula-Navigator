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

TAB="$(printf '\t\t\t\t\t')"
LINE="$(printf '=%.0s' {1..45})"

# Terminal width
TERM_WIDTH=$(tput cols)
SCREEN_WIDTH=$(( term_width * 70 / 100 ))

# Clear screen and print header
header() {
    clear
    echo -e ""
    echo -e "\t\t\t\t\t${CYAN}**************************************************************************${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Nebula Navigator      \t\t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              A GALAXY STAR RECORD SYSTEM      \t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Developed by: Nazmul and Fuad      \t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Green University Bangladesh      \t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**************************************************************************${RESET}"
}

# Login function
login() {
    attempts=0
    while [ $attempts -lt 3 ]; do
        header
        echo -e "${TAB}${YELLOW}LOGIN${RESET}"
        read -p "${TAB}Username: " username
        read -s -p "${TAB}Password: " password
        echo
        if grep -q "^$username|$password$" "$USERS_FILE"; then
            echo -e "${TAB}${GREEN}Login successful!${RESET}"
            sleep 1
            mainMenu
            # return 0
        else
            echo -e "${TAB}${RED}Invalid credentials!${RESET}"
            ((attempts++))
            sleep 1
        fi
    done
    echo -e "${TAB}${RED}Too many failed attempts. Exiting.${RESET}"
    exit 1

}

# Menu display
menu() {
    header
    echo -e "${TAB}${YELLOW}[1]${RESET} Add New Star"
    echo -e "${TAB}${CYAN}[2]${RESET} View All Stars"
    echo -e "${TAB}${MAGENTA}[3]${RESET} Search Star by Name"
    echo -e "${TAB}${BLUE}[4]${RESET} Edit Star Info"
    echo -e "${TAB}${RED}[5]${RESET} Delete Star"
    echo -e "${TAB}${GREEN}[6]${RESET} Show Distance of a Star"
    echo -e "${TAB}${WHITE}[7]${RESET} Logout"
    echo -e "${TAB}${WHITE}[8]${RESET} Exit"
    echo "${TAB}${LINE}"
    echo -n "${TAB}Choose an option [1-8]: "
}

# Add a new star
add_star() {
    header
    echo -e "${TAB}\t\t\t${YELLOW}ADD NEW STAR${RESET}"
    id=$(($(wc -l < "$DATA_FILE") + 1))
    printf -v ${TAB} id "%03d" $id
    read -p "${TAB}Star Name: " name
    read -p "${TAB}Star Type: " type
    read -p "${TAB}Distance (in km): " distance
    read -p "${TAB}Short Description: " desc
    echo "$id|$name|$type|$distance|$desc" >> "$DATA_FILE"
    echo -e "${TAB}${GREEN}Star added successfully!${RESET}"
    read -p "${TAB}Press Enter to return to menu..."
}

# View all stars
view_stars() {
    header
    
    echo -e "${TAB}ALL STARS RECORDED"
    echo -e "${LINE}${LINE}${LINE}"
    echo -e "${WHITE}ID${RESET} |\t${WHITE}NAME${RESET} \t|\t ${WHITE}TYPE${RESET} \t|\t ${WHITE}DISTANCE${RESET} |${TAB} ${WHITE}DESCRIPTION${RESET}"
    echo -e "${LINE}${LINE}${LINE}"

    if [ -s "$DATA_FILE" ]; then
        sort -t '|' -k1n "$DATA_FILE" | column -s '|' -t
    else
        echo -e "${RED}No records found.${RESET}"
    fi

    echo -e "${LINE}${LINE}${LINE}"
    read -p "Press Enter to return to menu..."
}

# Search star by name
search_star() {
    header
    echo -e "${TAB}${YELLOW}SEARCH STAR${RESET}"
    read -p " Enter star name (exact): " key
    key=$(echo "$key" | xargs)  # Trim spaces

    # Search for exact name match (case-insensitive)
    result=$(awk -F'|' -v k="$key" 'BEGIN{IGNORECASE=1} tolower($2) == tolower(k)' "$DATA_FILE")

    if [ -n "$result" ]; then
        echo -e " ${LINE}${LINE}${LINE}"
        echo -e "\n ${GREEN}Matching Result:${RESET}\n"
        echo -e " ${LINE}${LINE}${LINE}"

        # Process and print each matching line
        echo "$result" | while IFS='|' read -r id name type distance desc; do
            echo " ID:          $id"
            echo " Name:        $name"
            echo " Type:        $type"
            echo " Distance:    $distance km"
            echo " Description: $desc"
            echo -e "${LINE}${LINE}${LINE}"
        done
    else
        echo -e " ${RED}Star not found!${RESET}"
    fi

    echo
    read -p " Press Enter to return to menu..."
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

signUpMenu() {
    header
    echo "${TAB}Login Menu"
    echo "${TAB}${LINE}"
    echo -e "${TAB}${WHITE}[1]${RESET} Login"
    echo -e "${TAB}${WHITE}[2]${RESET} Exit"
    echo "${TAB}${LINE}"
    echo -n "${TAB}Choose an option [1-2]: "

    read choice
    case $choice in
        1) login ;;
        2) exit ;;
        *) echo -e "${TAB}${RED}Invalid input${RESET}"; sleep 1 ;;
    esac
}

mainMenu() {
  while true; do
    header
    menu
    read choice
    case $choice in
        1) add_star ;;
        2) view_stars ;;
        3) search_star ;;
        4) edit_star ;;
        5) delete_star ;;
        6) distance_star ;;
        7) signUpMenu ;;
        8) echo -e "${TAB}${GREEN}Thanks for using Nebula Navigator"${RESET}; exit ;;
        *) echo -e "${TAB}${RED}Invalid input${RESET}"; sleep 1 ;;
    esac
  done
}

# Main Program
function main() {
  while true; do
      mainMenu
  done
}

main


