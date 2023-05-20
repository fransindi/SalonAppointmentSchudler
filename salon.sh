#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
SERVICE_LIST=$($PSQL "select service_id, name from services order by service_id")
echo "$SERVICE_LIST" | while IFS='|' read SID NAME
do
  echo "$SID) $NAME"
done
SELECT_SERVICE
}


SELECT_SERVICE() {
  read SERVICE_ID_SELECTED
  CHECK_SERVICE=$($PSQL "select * from services where service_id='$SERVICE_ID_SELECTED'")


  if [[ -z $CHECK_SERVICE ]]
    then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU

  else
    CHECK_USER
  fi
}

CHECK_USER() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CHECK_PHONE_NUMBER=$($PSQL "select * from customers where phone='$CUSTOMER_PHONE'")
  
  if [[ -z $CHECK_PHONE_NUMBER ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  GET_APPOINTMENT
 }
 
 GET_APPOINTMENT() {
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
 }

 
MAIN_MENU