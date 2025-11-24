Rapport de TP – Simulation du potentiel électrostatique par méthode DF
1. Introduction

Dans le domaine de la compatibilité électromagnétique (CEM), la détermination du potentiel électrostatique est essentielle pour comprendre l’influence de structures conductrices sur leur environnement. Lorsque la géométrie devient complexe, la résolution analytique de l’équation de Laplace n’est plus envisageable. On utilise alors des méthodes numériques comme celle des différences finies (DF).

L’équation de Laplace dans un domaine sans charge s’écrit : ΔV=0

En discrétisant le domaine en une grille 2D, et avec un pas uniforme dx=dy=1, cette équation devient :

𝑉𝑖,𝑗=1/4(𝑉𝑖+1,𝑗+𝑉𝑖−1,𝑗+𝑉𝑖,𝑗+1+𝑉𝑖,𝑗−1)
Le but du TP est d’appliquer cette méthode DF dans un code Matlab pour résoudre le potentiel 𝑉(x,y) autour de deux conducteurs rectangulaires placés dans un domaine carré. On y ajoutera une étude du champ électrostatique, des lignes équipotentielles, ainsi qu’un calcul de capacité.
