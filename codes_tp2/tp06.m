% tp06.m - Script pour exécuter les simulations FDTD de la cavité vide et chargée

addpath('TP3_solution');

fprintf('Exécution de la simulation FDTD pour la cavité VIDE...\n');
FDTD_crbm_vide(); % Appelle la fonction de simulation pour la cavité vide

fprintf('\nExécution de la simulation FDTD pour la cavité CHARGÉE...\n');
FDTD_crbm_chargee(); % Appelle la fonction de simulation pour la cavité chargée

fprintf('\nSimulations terminées et résultats sauvegardés dans result_vide.txt et result_chargee.txt.\n');

