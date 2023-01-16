#!/usr/bin/env bash

# La variable _galaxy_ défini le répertoire de base ou est stocké la
# cartographie de la galaxie starwars. NE PAS MODIFIER, et l'utiliser
# comme chemin de base pour naviguer dans l'univers StarWars. Evitez
# les chemins relatifs relatifs.
subjdir=$PWD/$( dirname $0 )
galaxy=$subjdir/starwars

#
### Nombre de planètes d'une région - Arguments et tests
#
# Ce script doit retourner le nombre de _planètes_ présentes dans la
# région de la galaxie passée tant qu'argument.
#
# Usage: ./02-nombre_de_planetes.sh region
# Si:
#    - Aucune région n'est donnée en paramètre, on affichera "Region missing"
#    - Plus d'une région est passé en paramètre, on affichera "Too many regions"
#    - La région passée n'existe pas, on affichera "Unknown region"
#
# Sinon si l'usage est correct, on afficeha le nombre de planète de la
# région et on retournera.
#

