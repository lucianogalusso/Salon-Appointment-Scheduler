#! /bin/bash

#chmod +x salon.sh

#psql --username=freecodecamp --dbname=salon -c "SQL QUERY HERE"
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

#get services
SELECT_SERVICES="SELECT * FROM services;"

#get service
SELECT_SERVICE="SELECT * FROM services WHERE service_id="

#get customer
SELECT_CUSTOMER="SELECT * FROM customers WHERE phone="

#insert customer
INSERT_CUSTOMER="INSERT INTO customers(phone, name) VALUES"

#insert appointments
INSERT_APPOINTMENTS="INSERT INTO appointments(time, customer_id, service_id) VALUES"

SERVICES=$($PSQL "$SELECT_SERVICES")

SERVICE_ID_SELECTED=0

while [ "$SERVICE_ID_SELECTED" -eq 0 ]
do 
  echo "$SERVICES" | while IFS="|" read -r service_id name
  do
    echo "$service_id) $name"
  done

  echo -e "\n"
  read SERVICE_ID_SELECTED

  if ! [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; 
  then
    echo -e "Invalid selection, please try again.\n"
    SERVICE_ID_SELECTED=0
    continue
  fi

  SERVICE=$($PSQL "$SELECT_SERVICE$SERVICE_ID_SELECTED;")
  if [ -z "$SERVICE" ]; 
  then
    echo -e "Invalid selection, please try again.\n"
    SERVICE_ID_SELECTED=0
  else 
    IFS="|" read -r SERVICE_ID_SELECTED SERVICE_NAME <<< "$SERVICE"
  fi
done

echo -e "What's your phone number?\n"
read CUSTOMER_PHONE

CUSTOMER=$($PSQL "$SELECT_CUSTOMER'$CUSTOMER_PHONE';")
if [ -z "$CUSTOMER" ]; 
then
  echo -e "I don't have a record for that phone number, what's your name?\n"
  read CUSTOMER_NAME
  $PSQL "$INSERT_CUSTOMER ('$CUSTOMER_PHONE','$CUSTOMER_NAME');" > /dev/null
  CUSTOMER=$($PSQL "$SELECT_CUSTOMER'$CUSTOMER_PHONE';")  
  echo "$CUSTOMER"
fi

IFS="|" read -r CUSTOMER_ID CUSTOMER_PHONE CUSTOMER_NAME <<< "$CUSTOMER"

echo -e "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?\n"
read SERVICE_TIME

$PSQL "$INSERT_APPOINTMENTS ('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED);" > /dev/null

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."