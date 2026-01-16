% tp08_fft_function.m - Fonction modifiée pour calculer la FFT (sans tracé direct)

% Fonction visant à déterminer la FFT pour diverses valeurs de champ E
function [Freq, FFT_E, FFT_Ex, FFT_Ey, FFT_Ez] = FFT_crbm_modified(file_path, pas_de_temps)
% Parametres d'entree :
%   file_path     : Chemin vers le fichier d'entrée contenant les données du champ E
%   pas_de_temps  : Pas de temps utilisé lors de la simulation FDTD (Dt)

% fprintf('Calcul de la FFT pour le fichier : %s\n', file_path); % Commenté pour moins de verbosité

% Lecture des données
a1 = load(file_path);

% Récupération des composantes en champs E
Ex = a1(:,1);
Ey = a1(:,2);
Ez = a1(:,3);

clear a1; % Libérer la mémoire

nb_shoot = size(Ex, 1); % Nombre d'itérations en temps

% Calcul des differentes Transformées de Fourier
tfin = nb_shoot * pas_de_temps;   % Temps total
Discret = [0:nb_shoot-1];
Freq_full = Discret / tfin; % Utiliser un nom différent pour la fréquence "complète" 

% Calcul sur chaque composante
% Normalisation par (nb_shoot/2) pour obtenir l'amplitude correcte pour les fréquences positives
FFT_Ex_full = abs(fft(Ex)) / (nb_shoot/2);
FFT_Ey_full = abs(fft(Ey)) / (nb_shoot/2);
FFT_Ez_full = abs(fft(Ez)) / (nb_shoot/2);

% Calcul du champ total FFT_E
FFT_E_full = sqrt(FFT_Ex_full.^2 + FFT_Ey_full.^2 + FFT_Ez_full.^2);

% On ne garde que la première moitié des fréquences (partie positive, sans le point DC)
num_freq_points = floor(nb_shoot/2); % Ajusté pour éviter le point DC potentiellement problématique
Freq = Freq_full(2:num_freq_points+1); % Commencer à partir de la première fréquence non-DC
FFT_E = FFT_E_full(2:num_freq_points+1);
FFT_Ex = FFT_Ex_full(2:num_freq_points+1);
FFT_Ey = FFT_Ey_full(2:num_freq_points+1);
FFT_Ez = FFT_Ez_full(2:num_freq_points+1);

% Tracé du champ électrique total en fonction de la fréquence (COMMENTÉ)
% figure;
% plot(Freq, FFT_E);
% title(['Spectre en Fréquence du Champ Électrique Total (', file_path, ')']);
% xlabel('Fréquence (Hz)');
% ylabel('Amplitude (Champ Électrique)');
% grid on;

end % Fin de la fonction