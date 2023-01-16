#!/usr/bin/env bash

# La variable _galaxy_ défini le répertoire de base ou est stocké la
# cartographie de la galaxie starwars. NE PAS MODIFIER, et l'utiliser
# comme chemin de base pour naviguer dans l'univers StarWars. Evitez
# les chemins relatifs relatifs.
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars

#
### Occurences des années 2000 - Motifs
#
# Ecrire un script/une commande qui permette de lister tout les
# références des planètes de StarWars entre les année 2000 et 2009
# incluses
# On rappelle que la structure de la cartographie est la suivante
# ${galaxy}/_region_/_planete_/ANNEE-Titre pour chaque occurence de
# planète.
# 

regions=$(ls $galaxy)
for r in $regions
do
    for p in $(ls $galaxy/$r)
    do
	for a in $(ls $galaxy/$r/$p)
	do
	    reponse=$(echo $r/$p/$a | grep -v "Description" | grep "200[0-9]")
	    if [[ -n $reponse ]]
	    then
		echo $reponse
	    fi
	done
    done
done
