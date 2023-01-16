#!/usr/bin/env bash

# La variable _galaxy_ défini le répertoire de base ou est stocké la
# cartographie de la galaxie starwars. NE PAS MODIFIER, et l'utiliser
# comme chemin de base pour naviguer dans l'univers StarWars. Evitez
# les chemins relatifs relatifs.
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars

#
### Occurrences antérieures à 1980 - Motifs
# 
# Ecrire un script/une commande qui permette de lister toutes les
# références (_region_/_planete_/ANNEE-Titre) des planètes de StarWars
# antérieures à l'année 1980.
# Par simplification, on peut supposer qu'aucun titre n'a été produit avant 1900.
#
# Pour cela, on rappelle que la structure de la cartographie est la suivante
# $galaxie/_region_/_planete_/ANNEE-Titre pour chaque occurence de
# planète.
#


regions=$(ls $galaxy)
for r in $regions
do
    for p in $(ls $galaxy/$r)
    do
	for f in $(ls $galaxy/$r/$p)
	do
	    reponse=$(echo $r/$p/$f | grep -v "^D" | grep "19[0-7][0-9]")
	    if [[ -n $reponse ]]
	    then
	       echo $reponse
	    fi
	done
    done
done

