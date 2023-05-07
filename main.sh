#!/bin/bash

clear
echo -e "\e[1;31mWelcome to the Hospital Patient Management Portal System!!!\e[0m"
echo ""

while true
do
    echo "[L/l] List patients"
    echo "[A/a] Add a new patient"
    echo "[S/s] Search patient"
    echo "[D/d] Delete patient"
    echo "[E/e] Exit"
    echo ""
    read -p "Please select an option: " choice
    echo ""
    
    case $choice in
        [Ll])
            echo -e "\e[1;33mList of all patients:\e[0m"
            echo ""
            sort -t "," -k 2,2 -k 1,1 patients.csv | awk -F "," '{printf("%s\t%s\t%s\t%s\n", toupper($2), toupper($3), $4, $1)}'
            echo ""
            ;;
        [Aa])
            read -p "Enter first name: " first_name
            read -p "Enter last name: " last_name
            read -p "Enter phone number: " phone_number
            
            last_name_prefix=$(echo $last_name | cut -c1-4 | tr '[:lower:]' '[:upper:]')
            first_name_prefix=$(echo $first_name | cut -c1 | tr '[:lower:]' '[:upper:]')
            patient_id="$last_name_prefix$first_name_prefix"
            
            counter=2
            while grep -q $patient_id patients.csv; do
                patient_id="${last_name_prefix}${first_name_prefix}${counter}"
                counter=$((counter+1))
            done
            
            echo "$patient_id,$first_name,$last_name,$phone_number" >> patients.csv
            
            echo ""
            echo -e "\e[1;33mThanks for entering the new patient information...\e[0m"
            echo "The new Patient ID is $patient_id"
            echo "The new patient is added to the patient records."
            echo ""
            ;;
        [Ss])        
            read -p "Enter the last name to search: " search_name
            echo ""
            echo "Here are the matching records..."
            echo ""
            grep -i "$search_name" patients.csv | awk -F "," '{printf("%s\t%s\t%s\t%s\n", toupper($3), toupper($2), $4, $1)}'
            echo ""
            ;;
        [Dd])         
            read -p "Enter the patient's last name or part of it to delete: " delete_name
            echo ""
            grep -v -i "$delete_name" patients.csv > temp.csv && mv temp.csv patients.csv
            echo -e "\e[1;33mAll matching records have been deleted.\e[0m"
            echo ""
            ;;
        [Ee])
            echo -e "\e[1;32mThanks for using our patient portal system!\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31mInvalid option. Please try again.\e[0m"
            echo ""
            ;;
    esac
done
