#!/bin/bash

clear
echo -e "\e[1;31mWelcome to the Hospital Patient Management Portal System!!!\e[0m"
echo ""

while true; do
    echo "[L/l]List patients"
    echo "[A/a]Add a new patient"
    echo "[S/s]Search patient"
    echo "[D/d]Delete patient"
    echo "[E/e]Exit"
    echo ""
    read -p "Enter your choice: " choice
    echo ""

    if [[ $choice == "L" || $choice == "l" ]]; then
        echo -e "\e[1;34mListing all patients...\e[0m"
        echo ""
        sort -t ',' -k 2,2 -k 3,3 patients.csv | awk '{print toupper($2), toupper($3), $4, $1}' | column -t -s $'\t'
        echo ""
    elif [[ $choice == "A" || $choice == "a" ]]; then
        read -p "Enter first name: " fname
        read -p "Enter last name: " lname
        read -p "Enter phone number: " phone

        id=$(echo "${lname:0:4}${fname:0:1}" | tr '[:lower:]' '[:upper:]')

        while read line; do
            if [[ $line == *"$id"* ]]; then
                num=$(echo $line | awk -F',' '{print substr($1, 6)}')
                if [[ -z $num ]]; then
                    id="${id}1"
                else
                    id="${id}$(expr $num + 1)"
                fi
            fi
        done < patients.csv

        echo "The new Patient ID is $id"

        echo "$id,$fname,$lname,$phone" >> patients.csv
        echo "The new patient is added to the patient records."
        echo ""
    elif [[ $choice == "S" || $choice == "s" ]]; then
        read -p "Enter the last name to search: " search
        echo ""
        echo "Here are the matching records..."
        echo ""
        grep -i "$search" patients.csv | awk -F',' '{print toupper($2), toupper($3), $4, $1}' | column -t -s $'\t'
        echo ""
    elif [[ $choice == "D" || $choice == "d" ]]; then
        read -p "Enter the last name to delete: " delete
        echo ""
        grep -iv "$delete" patients.csv > patients_temp.csv
        mv patients_temp.csv patients.csv
        echo "Patient records matching \"$delete\" have been deleted."
        echo ""
    elif [[ $choice == "E" || $choice == "e" ]]; then
        echo -e "\e[1;31mThanks for using our patient portal system!\e[0m"
        echo ""
        break
    else
        echo "Invalid choice, please try again."
        echo ""
    fi
done
