#!/usr/bin/env bash

# La variable _galaxy_ défini le répertoire de base ou est stocké la
# cartographie de la galaxie starwars. NE PAS MODIFIER, et l'utiliser
# comme chemin de base pour naviguer dans l'univers StarWars. Evitez
# les chemins relatifs relatifs.
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars

#
### Plus grosse région de la galaxie - Commandes de bases sur système de fichiers
# 
# Ecrire un script/une commande qui permet de retourner la région de
# la galaxie la plus _massive_.
#
# On entend par _massive_ la région qui occupe le plus grand espace disque.
#
# On retournera sur une même ligne la taille et le nom de la région
#


regions=$(ls $galaxy)

du $galaxy/* | sort -rn | head -n1

