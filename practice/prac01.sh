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

header() {
    clear
    echo -e "\t\t\t\t\t${CYAN}==========================================================================${RESET}"
    echo -e "\t\t\t\t\t${CYAN}==\t              Nebula Navigator      \t\t\t\t==${RESET}"
    echo -e "\t\t\t\t\t${CYAN}==\t              A GALAXY STAR RECORD SYSTEM      \t\t\t==${RESET}"
    echo -e "\t\t\t\t\t${CYAN}==\t              Developed by: Nazmul and Fuad      \t\t==${RESET}"
    echo -e "\t\t\t\t\t${CYAN}==\t              Green University Bangladesh      \t\t\t==${RESET}"
    echo -e "\t\t\t\t\t${CYAN}==========================================================================${RESET}"
}

header2() {
    clear
    # echo -e "\t\t\t\t\t${CYAN}==========================================================================${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**************************************************************************${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Nebula Navigator      \t\t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              A GALAXY STAR RECORD SYSTEM      \t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Developed by: Nazmul and Fuad      \t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**\t              Green University Bangladesh      \t\t\t**${RESET}"
    echo -e "\t\t\t\t\t${CYAN}**************************************************************************${RESET}"
}



header2