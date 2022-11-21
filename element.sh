#!/bin/bash
EXIT_PROGRAM() {
  echo $1
}
READ_ELEMENT() {
  echo $1
}

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ ! $1 ]]
then
  EXIT_PROGRAM "Please provide an element as an argument."
else
  if [[ $1 -ge 1 ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi

  if [[ -z $ELEMENT ]]
  then
    EXIT_PROGRAM "I could not find that element in the database."
  else
    ELEMENT_FULL_PROPERTIES="$($PSQL "SELECT atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, atomic_mass, types.type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELEMENT")"
    echo $ELEMENT_FULL_PROPERTIES | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR MASS BAR TYPE
    do
      READ_ELEMENT "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi
