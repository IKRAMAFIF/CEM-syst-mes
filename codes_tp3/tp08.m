% tp08.m - Script pour effectuer l'analyse fréquentielle (FFT) des résultats FDTD

% Paramètres temporels (doivent correspondre à ceux utilisés dans les simulations FDTD)
Dt = 1e-10; % Pas de temps

% Ajoutez le répertoire TP3_solution au chemin d'Octave/MATLAB si ce n'est pas déjà fait
addpath('TP3_solution');

% --- Cavité VIDE ---
file_vide = 'TP3_solution/result_vide.txt';
fprintf('Analyse FFT pour la cavité VIDE...\n');
[freq_vide, fft_e_vide] = FFT_crbm_modified(file_vide, Dt);

% --- Cavité CHARGÉE ---
file_chargee = 'TP3_solution/result_chargee.txt';
fprintf('Analyse FFT pour la cavité CHARGÉE...\n');
[freq_chargee, fft_e_chargee] = FFT_crbm_modified(file_chargee, Dt);

fprintf('\nAnalyses FFT terminées. Les spectres en fréquence ont été générés.\n');

