#!/usr/bin/env bash

# La variable _galaxy_ défini le répertoire de base ou est stocké la
# cartographie de la galaxie starwars. NE PAS MODIFIER, et l'utiliser
# comme chemin de base pour naviguer dans l'univers StarWars. Evitez
# les chemins relatifs relatifs.
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars

# ex 02: Tests / arguments / commandes de bases
#
# Ecrire un script/une commande qui permette de compter le nombre
# d'occurence d'une planète (Le nombre de titres dans lesquels elle
# apparaît):
#   ./02-nombre_d_occurences.sh _region_ _planete_
#
# Ce script prendre en paramètre deux arguments. On ne fera pas
# attention aux éventuels arguments superflus.
# Si le nombre d'argument est incorrect, il devra renvoyer:
#         - "Region missing" si aucun argument n'est donné et quitter
#         - "Planet missing" si un seul argument est donné et quitter
#
# Ensuite, il renverra:
#         - "Region unknown" si la région n'existe pas et quitter
#         - "Planet unknown" si la planete n'existe pas et quitter
#
# Enfin, si tous ces tests sont passés. Il devra renvoyer le nombre
# d'occurences de la planète en question.
#

if [[ $# -ne 2 ]]
then
    if [[ $# -eq 0 ]]
    then
	echo "Region missing"
	exit
    fi
    if [[ $# -eq 1 ]]
    then
	echo "Planet missing"
	exit
    fi
fi


regions=$galaxy

a=$(ls $galaxy | grep $1 | wc -l)
if [[ $a -ne 1 ]]
then
    echo "Region unknown"
    exit
fi


b=$(ls $galaxy/$1 | grep $2 | wc -l)
if [[ $b -ne 1 ]]
then
    echo "Planet unknown"
    exit
fi

ls $galaxy/$1/$2 | grep -v "Description" | wc -l
