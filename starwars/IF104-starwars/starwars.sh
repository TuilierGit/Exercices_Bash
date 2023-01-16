#!/usr/bin/env bash

login=${login:-$(whoami)}
SHOW_SCRIPTS=${SHOW_SCRIPTS:-0}
WORKDIR=${WORKDIR:-.}
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars
EXPEDIR=$subjdir/.expected

mainpwd=$PWD
enable_timeout=0
global_timeout=0

PASSED=${PASSED:-"\033[32;1mPASSED\033[0m"}
FAILED=${FAILED:-"\033[31;1mFAILED\033[0m"}
TIMOUT=${TIMOUT:-"\033[31;1mTIME OUT\033[0m"}

errmsg=""
showdiff=${showdiff:-1}

#
# Check the presence of function
#   Return 1 if present and set errmsg
#   Return 0 if not present
#
function check_infunction() {
    local filename=$1
    local func=$2

    ( grep "\b$func\b" $filename ) > /dev/null 2>&1
    local rc=$?

    if [ $rc -eq 0 ]
    then
	errmsg="The  script $filename should not contain any '$func' command"
	value=$(( value + 1 ))
	return 1
    else
	return 0
    fi
}

#
# Check that the script has the correct right and do not include dangerous functions
# Return 0 if fails
# Return 1 on success
#
function check_script() {
    local filename=$1
    local rc=0
    local value=0

    if [ $SHOW_SCRIPTS -eq 1 ]
    then
	if [ -f $filename ]
	then
	    echo "----------- Content --------------"
	    grep -v "^\s*#" $filename | grep -v "^\s*$" | batcat -l bash --color always
	    echo "------------------------------------"
	fi
    fi

    printf "  %-80s" "Checking script $( basename $filename ) ... "
    errmsg=""
    if [ ! -f $filename ]
    then
	errmsg="The file $filename does not exist"
	value=1
    elif [ ! -x $filename ]
    then
	errmsg="The script $filename can not be executed"
	value=1
    fi

    # Check inlined function only i forst test is ok
    if [ $value -eq 0 ]
    then
	check_infunction $filename rm
	check_infunction $filename mv
	check_infunction $filename cp
    fi

    if [ $value -gt 0 ]
    then
	echo -e "---> $FAILED"
	if [ ! -z "$errmsg" ]
	then
	    echo "      => Error: $errmsg"
	else
	    echo "Please report to your teacher the error number 1"
	fi
	return 0
    else
	echo -e "---> $PASSED"
	return 1
    fi
}

# Check exercise w.r.t. expected text output 
# $1: command to check (script)
# $2: expected test output
# Returns: 0 is test PASSED, 1 if test FAILED
function checkdifftext() {
    if [ "$#" -lt "2" ];
    then
	echo "*** checkdifftext: bad arguments";
	exit 1
    fi

    local EXPECTED=$1
    local OUTPUT=$2

    (diff -q $EXPECTED $OUTPUT)  > /dev/null 2>&1 
    local rc=$?
    
    if [ $rc -ne 0 ]
    then
	echo "===================================" >> .report
	echo "  Returned:"	                   >> .report
	cat $OUTPUT                                >> .report
	echo "===================================" >> .report
	echo "  But was expecting:"                >> .report
	cat $EXPECTED                              >> .report
	echo "===================================" >> .report
	# echo "  Diff"                              >> .report
	# echo "-----------------------------------" >> .report
        # diff -ux --color=always $EXPECTED $OUTPUT  >> .report
	# echo "===================================" >> .report
    fi
    return $rc
}

function execmd() {
    local rc=0

    cleanup
    printf "    %-78s" "with cmd $* ... "

    if [ $enable_timeout -eq 1 -a $global_timeout -eq 1 ]
    then
	echo "I'm here"
	timeout --preserve-status --foreground -s9 5s $* > .output 2> .error
	rc=$?
    else
	$* > .output 2> .error
	rc=$?
    fi

    if [ $rc -eq 137 ]
    then
    	echo -e "---> $TIMOUT"
	echo "      => Error: Please make sure you are not waiting for input on stdin,"
	echo "                or check that you don't have an infinite loop"
    elif [ $rc -ne 0 ]
    then
    	echo -e "---> $FAILED"
	echo "      => Error: Do not execute correctly or do not return 0"
    fi
    return $rc
}

function cleanup() {
    rm -f .output .error .report
}    

function print_status() {
    if [ -s .report ]
    then
	echo -e "---> $FAILED"

	if [ $showdiff -ne 0 ]
	then
	    echo -n "Do you want the diff between your result and the expected ones ? [yes/no/Never] "
	    read answer
	    case $answer in
		[yYoO]* )
		    less .report
		    ;;
		[N]*)
		    showdiff=0
		    ;;
		*)
		    ;;
	    esac
	fi
    else
	echo -e "---> $PASSED"
    fi
}

function execmd_and_checkdiff() {
    local rc=0
    local note=0

    local expected=$1
    shift
    local CMD=$*
    
    execmd $CMD
    rc=$?
    if [ $rc -ne 0 ]; then return $note; fi

    sort $EXPEDIR/$expected                                > .expected.sorted
    sort .output | sed 's+^\./++' | sed 's+^.*starwars/++' > .output.sorted

    checkdifftext .expected.sorted .output.sorted
    rc=$?
    if [ $rc -eq 0 ]
    then
	note=$(( note + 1 ))
    fi

    print_status
    return $note
}

function check_01() {
    local rc=0
    local note=0
    local scriptfile="$WORKDIR/01-liste_appearances_before_1980.sh"

    enable_timeout=1
    
    echo ""
    echo " ---- Checking Exercice 01 - Appearances before 1980 ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    #
    # Check the results
    #
    echo "  Checking results of exercice 01 ... "
    execmd_and_checkdiff exo01.txt $scriptfile
    rc=$?
    note=$(( note + rc ))

    return $note
}

function check_01bis() {
    local rc=0
    local note=0
    local scriptfile="$WORKDIR/01-liste_appearances_00s.sh"

    enable_timeout=1
    
    echo ""
    echo " ---- Checking Exercice 01 - Appearances in 00s ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    #
    # Check the results
    #
    echo "  Checking results of exercice 01 ... "
    execmd_and_checkdiff exo01bis.txt $scriptfile
    rc=$?
    note=$(( note + rc ))

    return $note
}

function check_02() {
    local rc=0
    local note=0
    local scriptfile="$WORKDIR/02-nombre_de_planetes.sh"
    
    enable_timeout=1

    echo ""
    echo " ---- Checking Exercice 02 - Number of planets ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    #
    # Check the results
    #
    echo "  Checking results of exercice 02 ... "
    execmd_and_checkdiff exo02_none.txt     $scriptfile
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo02_toomany.txt  $scriptfile Bordure-Mediane Mondes-du-Noyau
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo02_unknown.txt  $scriptfile Espace-Oceanique
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo02_mediane.txt  $scriptfile Bordure-Mediane
    rc=$?
    note=$(( rc + note ))
    
    execmd_and_checkdiff exo02_colonies.txt $scriptfile Colonies
    rc=$?
    note=$(( rc + note ))
    
    return $note
}

function check_02bis() {
    local rc=0
    local note=0
    local scriptfile="$WORKDIR/02-nombre_d_occurences.sh"
    
    enable_timeout=1

    echo ""
    echo " ---- Checking Exercice 02 - Number of apparitions ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    #
    # Check the results
    #
    echo "  Checking results of exercice 02 ... "
    # No parameter
    execmd_and_checkdiff exo02bis_none.txt $scriptfile
    rc=$?
    note=$(( rc + note ))

    # Only Region
    execmd_and_checkdiff exo02bis_noplanet.txt $scriptfile Bordure-Mediane
    rc=$?
    note=$(( rc + note ))

    # Unknow Region
    execmd_and_checkdiff exo02bis_unknownregion.txt $scriptfile Espace-Oceanique Mondes-du-Noyau
    rc=$?
    note=$(( rc + note ))

    # Unknow Planete
    execmd_and_checkdiff exo02bis_unknownplanet.txt $scriptfile Bordure-Mediane Tatooine
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo02bis_mediane.txt $scriptfile Bordure-Mediane Naboo
    rc=$?
    note=$(( rc + note ))
    
    execmd_and_checkdiff exo02bis_colonies.txt $scriptfile Colonies Fondor
    rc=$?
    note=$(( rc + note ))
    
    return $note
}

function check_03() {
    local rc=0
    local note=0
    local failed=0
    local scriptfile="$WORKDIR/03-largest_area.sh"
    
    enable_timeout=1

    echo ""
    echo " ---- Checking Exercice 03 ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    #
    # Check the results
    #
    echo "  Checking results of exercice 03 ... "
    execmd $scriptfile
    rc=$?
    if [ $rc -ne 0 ]; then return $note; fi
			   
    echo -e "---> $PASSED"
    note=$(( note + 1 ))

    # Check size
    printf "    %-78s" "Check the returned size ... "

    correctsize=$( sed 's/^\s*\([0-9]*\)\s.*$/\1/' $EXPEDIR/exo03.txt )
    givensize=$( sed 's/^\s*\([0-9]*\)\s.*$/\1/' .output )

    givensize=${givensize:-0}
    if [ "$correctsize" -eq "$givensize" ]
    then
	echo -e "---> $PASSED"
	note=$(( note + 1 ))
    else
	echo "Incorrect size"            >> .report
	echo "   Expected: $correctsize" >> .report
	echo "   Found:    $givensize"   >> .report
	print_status
    fi

    # Check region
    printf "    %-78s" "Check the returned region ... "
    correctregion=$( sed 's+^.*\s\([^\s]*\)$+\1+' $EXPEDIR/exo03.txt )
    givenregion=$( sed 's+^.*/\([^/]*\)\s*$+\1+' .output |  sed 's+^.*\s\([^\s]*\)\s*$+\1+' )

    echo "" > .report
    if [ "$correctregion" = "$givenregion" ]
    then
	echo -e "---> $PASSED"
	note=$(( note + 1 ))
    else
	echo "Incorrect region"            >> .report
	echo "   Expected: $correctregion" >> .report
	echo "   Found:    $givenregion"   >> .report
	print_status
    fi

    return $note
}

function check_chevalier_largest() {
    local rc=0
    local note=0

    echo "    Checking the largest_number function"

    execmd_and_checkdiff exo1_largest_TV.txt largest_number TV
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_largest_game.txt largest_number game
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_largest_comic.txt largest_number Comic
    rc=$?
    note=$(( rc + note ))

    return $note
}

function check_chevalier_list() {
    local rc=0
    local note=0

    echo "    Checking the list_planets function"

    execmd_and_checkdiff exo1_list_1999.txt list_planets 1999-The_Phantom_Menace
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_list_2019.txt list_planets 2019-The_Mandalorian
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_list_2002.txt list_planets 2002-Attack_of_the_Clones
    rc=$?
    note=$(( rc + note ))

    return $note
}

function check_chevalier_sum() {
    local rc=0
    local note=0

    echo "    Checking the sum_year function"

    execmd_and_checkdiff exo1_sum_2017.txt sum_year 1999-The_Phantom_Menace 18
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_sum_2061.txt sum_year 2019-The_Mandalorian 42
    rc=$?
    note=$(( rc + note ))

    execmd_and_checkdiff exo1_sum_2053.txt sum_year 2002-Attack_of_the_Clones 51
    rc=$?
    note=$(( rc + note ))

    return $note
}

function check_chevalier() {
    local rc=0
    local note=0
    local scriptfile="$WORKDIR/1-ChevalierJedi.sh"

    enable_timeout=0

    echo ""
    echo " ---- Checking 1-ChevalierJedi.sh ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    execmd source $scriptfile
    rc=$?
    if [ $rc -ne 0 ]; then return $note; fi

    echo -e "---> $PASSED"
    note=$(( note + 1 ))

    #
    # Check the functions
    #
    check_chevalier_sum
    rc=$?
    note=$(( note + rc ))


    check_chevalier_list
    rc=$?
    note=$(( note + rc ))


    check_chevalier_largest
    rc=$?
    note=$(( note + rc ))


    return $note
}

function check_variable() {
    local variable=$1
    local value=$2

    printf "    %-78s" "Checking variable $variable... "

    if [ -z "$value" ]
    then
	echo -e "---> $FAILED (Not defined)"
	return 0
    fi

    local answer=$(grep $variable $EXPEDIR/maitre_jedi.txt | awk -F ':' '{ print $2 }' )
    if [ "$value" == "$answer" ]
    then
	echo -e "---> $PASSED ($value)"
	return 1
    else
	echo -e "---> $FAILED ($value)" 
    fi

    return 0
}

function check_variable_planete() {
    local variable=$1
    local value=$2

    printf "    %-78s" "Checking variable $variable... "

    if [ -z "$value" ]
    then
	echo -e "---> $FAILED (Not defined)"
	return 0
    fi

    local answer=$(grep $variable $EXPEDIR/maitre_jedi.txt | awk -F ':' '{ print $2 }' )
    answer=$( echo $answer |  sed  's+^.*/\([^/]*\)$+\1+' )
    value=$( echo $value |  sed 's+^.*/\([^/]*\)$+\1+' )

    if [ "$value" == "$answer" ]
    then
	echo -e "---> $PASSED ($value)"
	return 1
    else
	echo -e "---> $FAILED ($value)" 
    fi

    return 0
}

function check_maitre_jedi() {
    local rc=0
    local note=0
    local total=0
    local scriptfile="$WORKDIR/2-MaitreJedi.sh"

    enable_timeout=0

    echo ""
    echo " ---- Checking 2-MaitreJedi ---- "
    check_script $scriptfile
    rc=$?
    if [ $rc -eq 0 ]; then return $note; fi
    note=$(( note + 1 ))

    execmd source $scriptfile
    rc=$?
    if [ $rc -ne 0 ]; then return $note; fi
    
    echo -e "---> $PASSED"
    note=$(( note + 1 ))

    check_variable typemedia $typemedia
    rc=$?
    note=$(( note + rc ))


    check_variable titre $titre
    rc=$?
    note=$(( note + rc ))


    check_variable_planete planete $( echo $planete | sed 's+^.*/\([^/]*\)$+\1+' )
    rc=$?
    note=$(( note + rc ))


    check_variable destination $( echo $destination | sed 's+^.*/\([^/]*\)$+\1+' )
    rc=$?
    note=$(( note + rc ))


    check_variable solution $( echo $solution | sed 's+^\./++' | sed 's+^.*starwars/++' )
    rc=$?
    note=$(( note + rc ))


    if [ $rc -eq 1 ]
    then
	echo ""
	echo -n "   "
	cat $solution
	echo ""
    fi

    return $note
}

note_finale=0

check_01
note=$?
note_finale=$(( note_finale + note ))


check_01bis
note=$?
note_finale=$(( note_finale + note ))


# check_02
# note=$?
# note_finale=$(( note_finale + note ))


check_02bis
note=$?
note_finale=$(( note_finale + note ))


check_03
note=$?
note_finale=$(( note_finale + note ))


check_chevalier
note=$?
note_finale=$(( note_finale + note ))


check_maitre_jedi
note=$?
note_finale=$(( note_finale + note ))


#echo -e "\n\tCurrent grade (without coefficient): $note_finale / 30\n\n"
#echo -e "\n\tCurrent grade (without coefficient): $note_finale / 31\n\n"

#exit $note_finale
