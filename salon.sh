#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon App ~~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo "Welcome to My Salon, how may I help you?" 
  fi

  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) BOOK_APPT $SERVICE_ID_SELECTED ;;
    2) BOOK_APPT $SERVICE_ID_SELECTED ;;
    3) BOOK_APPT $SERVICE_ID_SELECTED ;;
    4) BOOK_APPT $SERVICE_ID_SELECTED ;;
    5) BOOK_APPT $SERVICE_ID_SELECTED ;;
    *) SERVICE_MENU "I could not find that service. What would you like today?" ;;
  esac
}

BOOK_APPT() {
  # get the name of the selected service_id
  SERVICE_ID_SELECTED=$1
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # ask for phone number and get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  # if the customer does not exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # ask for name and create a new customer
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  # get customer_id for the found or newly created customer
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # ask for time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # insert the appointment
  INSERT_APPT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 

  # display appointment message
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}


SERVICE_MENU