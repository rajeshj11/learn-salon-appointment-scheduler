#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

SERVICE_MENU(){
  SERVICES=$($PSQL "select * from services")
  if [[ $1 ]]; then
    echo -e "\n$1"
    else 
      echo- e "\nServices available:\n" 
  fi
  if [[ -z $SERVICES ]]; then
    echo -e "\nNo services Found."
    else
     echo "$SERVICES" | while read -r S_ID BAR S_NAME
     do
       echo "$S_ID) $S_NAME"
      (( i++ ))
     done
     echo -e "\nSelect the service you need:"
     read SERVICE_ID_SELECTED
     SERVICE_ID=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
     if [[ -z $SERVICE_ID ]]; then 
        SERVICE_MENU "Inncorect Service Choice. Please provide given services:"
        return;
     fi   
     echo -e "\nWhat is your phone number?"
     read CUSTOMER_PHONE
     CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
     if [[ -z $CUSTOMER_ID ]]; then
     
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      #create new customer
      INSERT_NEW_CUSTOMER=$($PSQL "insert into customers (name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      echo $INSERT_NEW_CUSTOMER
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
      else
      CUSTOMER_NAME=$($PSQL "select name from customers where customer_id='$CUSTOMER_ID'")
     fi    
     echo -e "\nSelect the time:"
     read SERVICE_TIME
     pg_dump -cC --inserts -U freecodecamp salon > salon.sql
     INSERT_NEW_APPOINTMENT=$($PSQL "insert into appointments (service_id, customer_id, time) values('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME')")
     echo $INSERT_NEW_APPOINTMENT "appointment record"
     SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
     echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

SERVICE_MENU
