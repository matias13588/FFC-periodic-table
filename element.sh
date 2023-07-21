#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no arg input
if [[ -z $1 ]]
then
    # inform user and end program
    echo "Please provide an element as an argument."
    exit
fi

# if argument is a number
if [[ $1 =~ ^[1-9]+$ ]]
then
    # get data
    ELEMENT_DATA=$($PSQL "
        SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
        FROM elements 
        JOIN properties USING(atomic_number) 
        JOIN types USING(type_id) 
        WHERE atomic_number = '$1'
    ")
else
    # if argument is string
    ELEMENT_DATA=$($PSQL "
        SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
        FROM elements 
        JOIN properties USING(atomic_number) 
        JOIN types USING(type_id) 
        WHERE name = '$1' OR symbol = '$1'
    ")
fi

# element not in db
if [[ -z $ELEMENT_DATA ]]
then
    echo "I could not find that element in the database."
    exit
fi

echo $ELEMENT_DATA | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done