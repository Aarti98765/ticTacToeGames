#!/bin/bash -x

#CONSTANTS
PLAYER="X"
COMPUTER="O"

#VARIABLES
turn=9
counter=false
gameCount=1

echo "welcome in tic tac toe game"
declare -a boardPosition
#TOSS TO PLAY FIRST
function whoPlayFirst() {
	tossResult=$((RANDOM%2))
	if [ $tossResult -eq 1 ]
	then
		echo "PLAYER play first"
		printBoard
		playGame $tossResult
	else
		echo "COMPUTER play first"
		printBoard
		playGame $tossResult
	fi
}

#DISPLAY BOARD
function printBoard () {
	index=1
	for ((Counter=0; Counter<3; Counter++))
	do
		printf "\t\t\t |     |     |     |\n"
		printf "\t\t\t |  "${boardPosition[index]}"  |  "${boardPosition[index+1]}"  |  "${boardPosition[index+2]}"  |\n"
		printf "\t\t\t |-----|-----|-----|\n"
		index=$(($index+3))
	done
}
for (( index=1; index<=9; index++ ))
do
 	boardPosition[$index]=$index
done

#START GAME
function playGame() {
	flag=$1
  	while [ $counter == false ]
  	do
    		if [ $flag -eq 1 ]
    		then
      			playerTurn
        	else
			computerTurn
	        fi
		((gameCount++))
  	done
}
#PLAYERTURN FUNCTION IS TO PLAY THE PLAYER 
function playerTurn() 
{
        echo "Player Enter your Slot :"
      	read cellNumber
	if [[ ( "${boardPosition[$cellNumber]}" == $PLAYER ) || ( "${boardPosition[$cellNumber]}"   == $COMPUTER ) ]]
	then
		echo "Slot already taken, Re-enter slot number"
		playGame $flag
	else
      		boardPosition[$cellNumber]=$PLAYER
      		printBoard
      		checkWinCondition $PLAYER
		flag=0
	fi
}
#ALL WINNING CONDITIONS FOR PLAYER
function checkWinCondition(){
	checkRows $1
	checkColumns $1
	checkDiagonals $1
	gameTieCheck
}
#WINNING AT ROWS
function checkRows(){
	loopCheck=1
	position=1
	while [ $loopCheck -le 3 ]
	do
		if [[ ${boardPosition[$position]} == ${boardPosition[$(($position+1))]} ]] && 
		   [[ ${boardPosition[$(($position+1))]} == ${boardPosition[$(($position+2))]} ]] && 
	           [[ ${boardPosition[$position]} == $1 ]]
		then
			counter=true
			echo "$1 Won"
			exit
		else
			position=$(($position+3))
		fi
		((loopCheck++))
	done
}

#WINNING AT DIAGONALS
function checkDiagonals () {
	loopCheck=1
	position=1
	while [ $loopCheck -le 3 ]
	do
		if [[ ${boardPosition[$position]} == ${boardPosition[$(($position+4))]} ]] && 
		   [[ ${boardPosition[$(($position+4))]} == ${boardPosition[$(($position+8))]} ]] && 
		   [[ ${boardPosition[$position]} == $1 ]]
		then
			counter=true
			echo "$1 Won"
			exit
		elif [[ ${boardPosition[$(($position+2))]} == ${boardPosition[$(($position+4))]} ]] && 
		     [[ ${boardPosition[$(($position+4))]} == ${boardPosition[$(($position+6))]} ]]  && 
		     [[ ${boardPosition[$(($position+2))]} == $1 ]]
		then
			echo "$1 Won"
			counter=true
			exit
		fi
	        (( loopCheck++ ))
	done
}
#WINNING AT COLUMNS
function checkColumns () {
	loopCheck=1
	position=1
	while [ $loopCheck -le 3 ]
	do
		if [[ ${boardPosition[$position]} == ${boardPosition[$(($position+3))]} ]] && 
		   [[ ${boardPosition[$(($position+3))]} == ${boardPosition[$(($position+6))]} ]]  && 
		   [[ ${boardPosition[$position]} == $1 ]]
		then
			echo "$1 Won"
			counter=true
			exit
		else
			position=$(($position+1))
		fi
		((loopCheck++))
	done
}
#CHECK TIE OR NOT
function gameTieCheck () {
	if [ $gameCount -ge 9 ]
	then
		echo "Match Tie"
		counter=true
	fi
}

#COMPUTERTURN FUNCTION IS TO PLAY THE COMPUTER
function computerTurn() 
{
	echo "Computer Enter your Slot"
	randomCellNumber=$( checkCompWinningCondition )
	echo "randomCellNumber : $randomCellNumber"
	if [[ ( "${boardPosition[$randomCellNumber]}" == $PLAYER ) || 
	   ( "${boardPosition[$randomCellNumber]}" == $COMPUTER ) ]]
	then
		echo "Slot already take"
		playGame $flag
	else
		boardPosition[$randomCellNumber]=$COMPUTER
		printBoard
      		checkWinCondition $COMPUTER
		flag=1
	fi
}
#COMPUTERS WINNING CONDITIONS
function checkCompWinningCondition(){
	computerRowPosition=$( winComAtRowPosition )
	computerColumnPosition=$( winComAtColoumnPosition )
	computerDiagonalPosition=$( winComAtDiagonalPosition )
	computerBlockPosition=$( blockPlayerWin )
	computerTakesCorners=$( takesCorner )
	computerTakesCenter=$( takesCenter )
	computerTakesSide=$( takesSide )
        if [[ $computerRowPosition -gt 0 ]]
	then
		position=$computerRowPosition
	elif [[ $computerColumnPosition -gt 0 ]]
	then
		position=$computerColumnPosition
	elif [[ $computerDiagonalPosition -gt 0 ]]
	then
		position=$computerDiagonalPosition
	elif [[ $computerBlockPosition -gt 0 ]]
	then 
		position=$computerBlockPosition
	elif [[ $computerTakesCenter -gt 0 ]]
        then
		position=$computerTakesCenter
	elif [[ $computerTakesSide -gt 0 ]]
	then
		position=$computerTakesSide
	else
		position=$computerTakesCorner
	fi
	echo $position
}
#COMPUTER CHECKS WINNING AT ROWS
function winComAtRowPosition(){
	local row=0;
	for (( count=1; count<=3; count++ ))
	do
		row=$(( $row+1 ))
		if [[ ${boardPosition[$row]} == ${boardPosition[$row+1]} ]] || 
		   [[ ${boardPosition[$row+1]} == ${boardPosition[$row+2]} ]] || 
		   [[ ${boardPosition[$row+2]} == ${boardPosition[$row]} ]]
		then
			for (( innerLoop=$row; innerLoop<=$(($row+2)); innerLoop++ ))
			do
				if [[ ${boardPosition[$innerLoop]} -ne $COMPUTER ]] && 
				   [[ ${boardPosition[$innerLoop]} -ne $PLAYER ]]
				then
					positionToReturn=$innerLoop
				fi
			done
		else
	        	row=$(( $row+3 ))
		fi
	done
	echo $positionToReturn
}
#COMPUTER CHECKS WINNING AT COLUMNS
function winComAtColoumnPosition(){
	local column=0;
	for (( count=1; count<=3; count++ ))
	do
		column=$(( $column+1 ))
		if [[ ${boardPosition[$column]} == ${boardPosition[$column+3]} ]] || 
		   [[ ${boardPosition[$column+3]} == ${boardPosition[$column+6]} ]] || 
		   [[ ${boardPosition[$column+6]} == ${boardPosition[$column]} ]] 
		then
			for (( innerLoop=1; innerLoop<=3; innerLoop++ ))
			do
				if [[ ${boardPosition[$column]} -ne $COMPUTER ]] || 
				   [[ ${boardPosition[$innerLoop]} -ne $PLAYER ]]
				then
					positionToReturn=$column
				fi
				column=$(( $column+1 ))
			done
		fi
	done
	echo $positionToReturn
}
#COMPUTER CHECKS WINNING AT DIAGONALS
function winComAtDiagonalPosition(){
 	winCompAtDiagnalFirstSide=$( winCompAtDiagonalFirstSide )
 	winComAtDiagonalSecondSide=$( winCompAtDiagonalSecondSide )
 	if [[ $winCompAtDiagnalFirstSide -ne 0 ]]
 	then
		position=$winCompAtDiagnalFirstSide
 	else
		position=$winComAtDiagonalSecondSide
 	fi
 	echo $position
}
function winCompAtDiagonalFirstSide(){
	local diagCount=1;
	if [[ ${boardPosition[$diagCount]} == ${boardPosition[$diagCount+4]} ]] || 
	   [[ ${boardPosition[$diagCount+4]} == ${boardPosition[$diagCount+8]} ]] || 
	   [[ ${boardPosition[$diagCount+8]} == ${boardPosition[$diagCount]} ]]
	then
		for (( innerLoop=1; innerLoop<=3; innerLoop++ ))
		do
			if [[ ${boardPosition[$diagCount]} -ne $COMPUTER ]] || 
			   [[ ${boardPosition[$innerLoopCounter]} -ne $PLAYER ]]
			then
				positionToReturn=$diagCount
			fi
			diagCount=$(( $diagCount+4 ))
		done
	fi
	echo $positionToReturn
}
function winCompAtDiagonalSecondSide(){
   local count=1
	if [[ ${boardPosition[$count+2]} == ${boardPosition[$count+4]} ]] || 
	   [[ ${boardPosition[$count+4]} == ${boardPosition[$count+6]} ]] || 
	   [[ ${boardPosition[$count+6]} == ${boardPosition[$count+2]} ]]
	then
		for (( innerLoop=1; innerLoop<=3; innerLoop++ ))
		do
			count=$(( $count+2 ))
			if [[ ${boardPosition[$count]} -ne $COMPUTER ]] || 
			[[ ${boardPosition[$innerLoopCounter]} -ne $PLAYER ]]
			then
				positionToReturn=$count
			fi
		done
	fi
	echo $positionToReturn
}
#COMPUTER CHECK FOR ALL BLOCK CONDITION
function blockPlayerWin(){
	rowBlockPosition=$( isCompRowBlock )
	columnBlockPosition=$( isCompColumnBlock )
   	diagonalBlockPosition=$( isCompDiagonalBlock )
	if [[ $rowBlockPosition -ne 0 ]]
	then
		blockValueForPlayer=$rowBlockPosition
	elif [[ $columnBlockPosition -ne 0 ]]
	then
		blockValueForPlayer=$columnBlockPosition
	else
		blockValueForPlayer=$diagonalBlockPosition
	fi
	echo $blockValueForPlayer
}
#CHECKING FOR ROWS
function isCompRowBlock(){
	local rowIndex=1
 	local position=0
	while(($rowIndex<9))
	do
		if [[ ${boardPosition[$rowIndex]} == $PLAYER && ${boardPosition[$(($rowIndex+1))]} == $PLAYER 
	   		&& ${boardPosition[$(($rowIndex+2))]} == $EMPTY ]]
		then
			position=$(( $rowIndex+2 ))
			return
		elif [[ ${boardPosition[$rowIndex]} == $PLAYER && ${boardPosition[$(($rowIndex+2))]} == $PLAYER 
	     		&& ${boardPosition[$(($rowIndex+1))]} == $EMPTY ]]
		then
			position=$(( $rowIndex+1 ))
			return
		elif [[ ${boardPosition[$(($rowIndex+2))]} == $PLAYER && ${boardPosition[$(($rowIndex+1))]} == $PLAYER 
	     		&& ${boardPosition[$rowIndex]} == $EMPTY ]]
		then
			position=$rowIndex
			return
		fi
		rowIndex=$(( $rowIndex+3 ))
	done
	echo $position
}
#CHECKING FOR COLUMNS
function isCompColumnBlock(){
	local position=0
	for ((columnIndex=1; columnIndex<=3; columnIndex++))
	do
		if [[ ${boardPosition[$columnIndex]} == $PLAYER && ${boardPosition[$(($columnIndex+3))]} == $PLAYER 
		   && ${boardPosition[$(($columnIndex+6))]} == $EMPTY ]]
		then
			position=$(( $columnIndex+6 ))
			return
		elif [[ ${boardPosition[$columnIndex]} == $PLAYER && ${boardPosition[$(($columnIndex+6))]} == $PLAYER 
		     && ${boardPosition[$(($columnIndex+3))]} == $EMPTY ]]
		then
			position=$(( $columnIndex+3 ))
			return
		elif [[ ${board[$(($columnIndex+3))]} == $PLAYER && ${boardPosition[$(($columnIndex+6))]} == $PLAYER 
		&& ${boardPosition[$columnIndex]} == $EMPTY ]]
		then
			position=$columnIndex
			return
		fi
	done
	echo $position
}

#CHECKING FOR \ DIAGONAL
function isCompDiagonalBlock(){
	firstSideDiagonalValue=$( isDiagonalBlockFirstSide )
  	secondSideDiagonalValue=$( isDiagonalBlockSecondSide )
  	if [[ $firstSideDiagonalValue -ne 0 ]]
  	then
		positioOfDiagonalBlock=$firstSideDiagonalValue
  	else
		positionOfDiagonalBlock=$secondSideDiagonalValue
  	fi
  	echo $positionOfDiagonalBlock
}
#CHECKING FOR DIAGONAL FIRST SIDE TO BLOCK
function isDiagonalBlockFirstSide(){   
	local position=0
	if [[ ${boardPosition[1]} == $PLAYER && ${boardPosition[5]} == $PLAYER 
                && ${boardPosition[9]} == $EMPTY ]]
	then
		position=9
		return
	elif [[ ${boardPosition[1]} == $PLAYER && ${boardPosition[9]} == $PLAYER 
                && ${boardPosition[5]} == $EMPTY ]]
	then
		position=5
		return
	elif [[ ${boardPosition[5]} == $PLAYER && ${boardPosition[9]} == $PLAYER 
                && ${boardPosition[1]} == $EMPTY ]]
	then
		position=1
		return
	fi
	echo $position
}
#CHECKING FOR DIAGONAL FIRST SIDE TO BLOCK
function isDiagonalBlockSecondSide(){	
	local position=0
   	if [[ ${boardPosition[3]} == $PLAYER && ${boardPosition[5]} == $PLAYER 
	        && ${boardPosition[7]} == $EMPTY ]]
	then
		position=7
		return
	elif [[ ${boardPosition[3]} == $PLAYER && ${boardPOsition[7]} == $PLAYER 
	        && ${boardPosition[5]} == $EMPTY ]]
	then
		position=5
		return
	elif [[ ${boardPosition[7]} == $PLAYER && ${boardPosition[5]} == $PLAYER  
		&& ${boardPosition[3]} == $EMPTY ]]
	then
		position=3
		return
	fi
	echo $position
}
#COMPUTER CHECKS FOR CORNERS
function takesCorner(){
	local count=1
	local positionToReturn=1
	for (( innerLoop=1; innerLoop<=2; innerLoop++ ))
	do
		if [[ ${boardPosition[$count]} -ne $COMPUTER ]] || 
        	   [[ ${boardPosition[$count]} -ne $PLAYER ]]
		then
	        	positionToReturn=$count
		elif [[ ${boardPosition[$count+2]} -ne $COMPUTER ]] || 
           	     [[ ${boardPosition[$count+2]} -ne $PLAYER ]]
		then
			positionToReturn=$(( $count+2 ))
		fi
		count=$(( $count+6 ))
	done
	echo $positionToReturn
}
#COMPUTER CHECKS FOR CENTER
function takesCenter(){
	local count=5
	if [[ ${boardPosition[$count]} == $EMTY ]] 
	then
		positionToReturn=$count	
	fi
	echo $positionToReturn
}
#COMPUTER CHECK FOR SIDES
function takesSide(){
	local count=1
	if [[ ${boardPosition[$(($count+1))]} -ne $COMPUTER ]] && [[ ${boardPosition[$(($count+1))]} -ne $PLAYER ]]
	then
		positionToReturn=$(($count+1))
	elif [[ ${boardPosition[$(($count+3))]} -ne $COMPUTER ]] && [[ ${boardPosition[$(($count+3))]} -ne $PLAYER ]]
	then
		positionToReturn=$(($count+3))
	elif [[ ${boardPosition[$(($count+5))]} -ne $COMPUTER ]] && [[ ${boardPosition[$(($count+5))]} -ne $PLAYER ]]
	then
		positionToReturn=$(($count+5))
	elif [[ ${boardPosition[$(($count+7))]} -ne $COMPUTER ]] && [[ ${boardPosition[$(($count+7))]} -ne $PLAYER ]]
	then
		positionToReturn=$(($count+7))
	fi
	echo $positionToReturn
}

whoPlayFirst
