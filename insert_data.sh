#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

while IFS=',', read -r YR RND WIN OPP WIN_G OPP_G
do
#check if winner or opponent in teams
WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WIN'")

#if not found

if [ -z $WINNER ]
  then
  if [[ $WIN != 'winner' ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
  fi
fi

OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPP'")
if [ -z $OPPONENT ]
  then
  if [[ $OPP != 'opponent' ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
  fi
fi

#look for winner ID
#look for oponnent ID
WINID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
OPPID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
#insert year, round, winner ID, oppoent ID, winner goals, opponent goals
echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YR, '$RND', $WINID, $OPPID, $WIN_G, $OPP_G)")


done <games.csv