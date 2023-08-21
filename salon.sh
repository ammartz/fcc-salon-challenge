#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"
SERVICES_LIST(){
SERVICES="$($PSQL "select service_id, name from services")"
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
echo "$SERVICE_ID) $SERVICE_NAME"
done
}
SERVICES_LIST
echo -e "\nChoose a service:"
read SERVICE_ID_SELECTED
#if service doesn't exist
GET_SERVICE_ID="$($PSQL "select service_id, name from services where service_id = $SERVICE_ID_SELECTED ")"
if [[ -z $GET_SERVICE_ID ]]
then
SERVICES_LIST
else
echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE
#get customer name
CUSTOMER_NAME="$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE' ")"
CUSTOMER_ID="$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE' ")"

if [[ -z $CUSTOMER_NAME ]]
then
echo -e "\nEnter your name:"
read CUSTOMER_NAME
INSERT_CUSTOMER="$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE') ")"
CUSTOMER_ID="$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE' ")"
fi
echo -e "\nEnter the service time:"
read SERVICE_TIME
INSERT_APPO="$($PSQL "insert into appointments(service_id, customer_id, time) values('$SERVICE_ID_SELECTED','$CUSTOMER_ID', '$SERVICE_TIME') ")"
SERVICE_NAME_SELECTED="$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED ")"
echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
