---
Title: Consignes du sujet StarWars
---

# Consignes

  Tout d'abord félicitations pour avoir réussi à accéder aux consignes
  de l'examen :).
  
  **Attention** Ce sujet peut contenir des spoilers, ne perdez pas de
  temps à lire tout les fichiers et vous ne serez pas spoilé. La
  connaissance de l'univers n'aidera pas à trouver les réponses.
  
  Dans une galaxie fort fort lointaine, Luke Skywalker est parti se
  cacher dans une planète inconnue de la rébellion. Heureusement pour
  Rey, et pour vous, il a laissé quelques traces de son passage dans
  les planètes qu'il a visitées avant d'aller se cacher. Le but de
  l'exercice va ainisi être d'aider Rey à retrouver ce cher Luke un
  sabre laser, ou plutôt un clavier, à la main.

  Heureusement Yoda est apparu pour nous donner quelques indices
  (incompréhensibles).

  Le sujet se décompose en plusieurs parties. La partie Padawan
  (`0x-*.sh`) pour se mettre en jambe est indépendante, la partie
  Chevalier Jedi (`1-ChevalierJedi.sh`) débute la recherche de Luke,
  et enfin la partie Maître Jedi (`2-MaitreJedi.sh`) repose sur la
  partie précédente pour le rencontrer. Dans chacune d'elle, vous
  allez devoir implémentez un ensemble de fonctions dans des scripts
  bash par difficulté plus ou moins croissante et que vous pourrez
  tester en exécutant la commande:
  
~~~sh
./starwars.sh
~~~

** N'oubliez pas de faire la commande `rendu` régulièrement (_depuis
le répertoire travail_)**

Le sujet est volontairement long et il n'est pas attendu que vous
fassiez tout, cependant faites attention de remettre des scripts en état
de fonctionnement.

# Padawan - Savoir se repérer dans la galaxie

Vous avez à votre disposition dans le répertoire `~/sujets/starwars`,
la liste de toutes les planètes du monde de StarWars structurée en
sous-répertoires comme suit:

~~~sh
Region_de_la_Galaxie/Planete
~~~

Chacun des répertoires de planète va contenir un fichier `Description`
qui decrit la planète, comme par exemple:

~~~sh
> cat Colonies/Fondor/Description 
Type: Planète tellurique
Paysage: Déserts et terres en friche
Especes: Humains
Description:
Imperial manufacturing center with large shipyards. 
~~~

Dans ces répertoires, vous trouverez également un fichier par
apparition de la planète dans un _média_. Ces fichiers ont un nom qui
suit le format: `Annee-titre`, et le contenu de ces fichiers est le
type de média dans lequel la planète apparaît. Les médias possibles
sont:

~~~
Book
Comic
Film
Novella
Short story
Theme park
TV film
TV micro-series
TV series
Video game
VR game
~~~

On va commencer par faire quelques petites fonctions qui nous serviront plus tard.

## Listez les occurrences antérieures à 1980 - motifs 

Modifiez le script `01-liste_appearances_before_1980.sh` pour qu'il
affiche la liste de toutes les apparitions de planètes avant 1980 sous le format:

~~~
_region_/_planete_/ANNEE-Titre
~~~

## Listez les occurrences des années 2000 - motifs 

Modifiez le script `01-liste_appearances_00s.sh` pour qu'il affiche la
liste de toutes les apparitions de planètes dans les années 2000 sous
le format:

~~~
_region_/_planete_/ANNEE-Titre
~~~

A titre d'exemple, voici la liste des apparitions pour les années 70s telle qu'elle devrait être retournée:
~~~
Bordure-Exterieure/Dantooine/1977-A_New_Hope
Bordure-Exterieure/Kessel/1977-Star_Wars
Bordure-Exterieure/Tatooine/1977-A_New_Hope
Bordure-Exterieure/Yavin/1977-Star_Wars
Bordure-Exterieure/Yavin-IV/1977-Star_Wars
Bordure-Mediane/Kashyyyk/1978-Star_Wars_Holiday_Special
Mondes-du-Noyau/Alderaan/1977-A_New_Hope
Mondes-du-Noyau/Corellia/1977-A_New_Hope
Zone-d_expansion/Mimban/1978-Star_Wars_Legends:_Splinter_of_the_Mind_s_Eye
~~~

## Donnez le nombre de planètes d'une région - arguments et tests

Modifiez le script `02-nombre_de_planetes.sh` pour qu'il donne le
nombre de planètes présentes dans une région de la galaxie passer en
paramètre. 
On s'assurera de renvoyer:

 * `Region missing` si on ne passe pas de paramètre au script
 * `Too many regions` si on passe plus d'une région au script
 * `Unknown region` si on passe une région de la galaxie qui n'existe
   pas (nom inexistant, ou pas un répertoire). 

## Donnez le nombre d'apparition d'une planète - arguments et tests

Modifiez le script `02-nombre_d_occurences.sh` pour qu'il donne le
nombre d'apparitions d'un planète dans les différents média liés à StarWars. 

Ce script prendra deux arguments en paramètre. Une _région_ et une
_planete_ et retournera le nombre d'apparition si la région existe, et
si la planète existe dans cette région.

On s'assurera de renvoyer:

 * `Region missing` si on passe aucun paramètre au script
 * `Planet missing` si on ne passe qu'un seul paramètre au script
 * `Region unknown` si la région n'existe pas
 * `Planet unknown` si la planète n'existe pas

## Trouvez la plus grosse région de la galaxie - commandes de bases 

Modifiez le script `03-largest_area.sh` pour qu'il affiche la plus
grosse region de la galaxie. _Rq: On ne parle pas du nombre de
planètes, mais de leur taille._ 

On affichera la taille et la région de la galaxie.

# Chevalier Jedi - Préparation du voyage

Maintenant que vous pensez avoir fait vos preuves en tant que Padawan,
vous pouvez passer Chevalier Jedi en implémentant les fonctions qui
seront nécessaires à la recherche de Luke Skywalker. Toutes ces
fonctions sont à implémenter dans le fichier `1-ChevalierJedi.sh`

## Sommer l'année d'un titre avec un nombre donné

Faire une fonction qui retourne le résultat de la somme entre l'année
d'un titre donné et un nombre passé en paramètre.

## Lister l'ensemble des planètes visitées pour un titre donné

On souhaite connaître la liste des planètes visitées pour un titre
donné. Ecrivez la fonction qui prend en paramètre un titre et qui
retourne la liste des répertoires de planètes référéncées par ce
titre.

## Trouver pour un type de media donné le titre visitant le plus grand nombre de planète

Afin de mener sa quête à bien, Rey doit voyager aux quatre coins de
la galaxie pour retrouver l'ensemble des indices laissés par Luke sur
son chemin. Il va donc falloir trouver pour chaque type de média, le
titre visitant le plus grand nombre de planètes.

_Remarque : pour simplification, on considérera que l'année fait partie intégrale du
titre. Ex : 2014-Star_Wars_Rebels et 2016-Star_Wars_Rebels sont deux titres différents_

_Indice_ : cut, awk, sort, uniq, grep, cat, sed, ...

# Maitre Jedi - A la recherche de Luke Skywalker

Yoda a laissé une information supplémentaire à Rey assez difficile à déchiffrer:
~~~
Afin de trouver Luke, le chemin marqué par R2D2 suivre tu devras.
Il a marqué tous les
sauts hyperespace dans les descriptions des planètes visitées sous la
forme `BipPlanete`, où Planete est remplacé par le nom de ta future
destination. Attention, R2D2 est un peu rouillé, il se peut qu'il aie
préfixé les sauts hyperespaces par les variantes Bap, Bop, Bup. Vous
serez arrivé à destination quand il n'y aura plus de saut à suivre.

Le chemin débute sur une des planètes visitées par le titre trouvé
précédemment. Il s'agit de l'avant-dernière planète (par ordre
alphabétique).
~~~

Il va falloir procéder par étapes en ajoutant le code nécessaire au
calcul de certaines variables dans le fichier `2-MaitreJedi.sh`. Il
est autorisé de chercher l'information manuellement et de stocker la
valeur dans le fichier, ce qui peut vous permettre de répondre aux
questions sans avoir complétement fourni les fonctions de la partie
Chevalier. Par ce biais, il est possible de ne pas répondre aux
questions dans l'ordre.

 1. Trouver parmi les fichiers de `Description` de planete, l'unique
    ligne qui commence par Yoda, elle vous indiquera le type de media
    qui nous intéresse (dernier mot de la ligne). Sauvegardez l'information trouvée dans la
    variable `typemedia` du script `maitre_jedi.sh`
 1. A partir de ce type de média, trouvez le titre qui visite le plus
    de planètes.
 1. Vous pouvez désormais lister les planètes visitées par ce titre.
 1. Le point de départ est l'avant dernière planète de cette liste par
    ordre alphabétique. _Indice pour vérifier: C'est la planète la
    plus visitée par les titres StarWars_
 1. Suivez le chemin laissé par R2D2 vous indiquant la prochaine
    planète à visiter. Sauvegarder le chemin parcouru dans le fichier
    `voyage.txt` avec à chaque ligne l'information `origine ->
    destination`
 1. Afficher la Description de la planète finale, elle vous donnera
    les dernières instructions.
