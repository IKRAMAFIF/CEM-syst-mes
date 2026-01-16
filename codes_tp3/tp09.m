% tp09.m - Visualisation et analyse des résultats fréquentiels FDTD (bande 80-150 MHz)

% Paramètres temporels (doivent correspondre à ceux utilisés dans les simulations FDTD)
Dt = 1e-10; % Pas de temps

% Ajoutez le répertoire TP3_solution au chemin d''Octave/MATLAB si ce n''est pas déjà fait
addpath('TP3_solution');

% Définir la plage de fréquence d''intérêt (80 MHz à 150 MHz)
f_min = 80e6;  % 80 MHz
f_max = 150e6; % 150 MHz

% --- Cavité VIDE ---
file_vide = 'TP3_solution/result_vide.txt';
fprintf('Analyse FFT pour la cavité VIDE...\n');
[freq_vide_full, fft_e_vide_full] = FFT_crbm_modified(file_vide, Dt);

% Filtrer les résultats pour la plage de fréquence spécifiée
idx_vide = find(freq_vide_full >= f_min & freq_vide_full <= f_max);
freq_vide_filtered = freq_vide_full(idx_vide);
fft_e_vide_filtered = fft_e_vide_full(idx_vide);

% --- Cavité CHARGÉE ---
file_chargee = 'TP3_solution/result_chargee.txt';
fprintf('Analyse FFT pour la cavité CHARGÉE...\n');
[freq_chargee_full, fft_e_chargee_full] = FFT_crbm_modified(file_chargee, Dt);

% Filtrer les résultats pour la plage de fréquence spécifiée
idx_chargee = find(freq_chargee_full >= f_min & freq_chargee_full <= f_max);
freq_chargee_filtered = freq_chargee_full(idx_chargee);
fft_e_chargee_filtered = fft_e_chargee_full(idx_chargee);

% --- Tracé comparatif ---
figure;
plot(freq_vide_filtered / 1e6, fft_e_vide_filtered, 'b', 'DisplayName', 'Cavité VIDE');
hold on;
plot(freq_chargee_filtered / 1e6, fft_e_chargee_filtered, 'r', 'DisplayName', 'Cavité CHARGÉE');
hold off;
title('Spectres en Fréquence des Champs Électriques (80-150 MHz)');
xlabel('Fréquence (MHz)');
ylabel('Amplitude du Champ Électrique');
legend('show');
grid on;

% --- Identification des fréquences de résonance (simplifié) ---
% Pour identifier les pics, on peut chercher les maxima locaux.
fprintf('\nFréquences de résonance identifiées (pics locaux) dans la bande [80MHz, 150MHz] :\n');

% Cavité VIDE
fprintf('Cavité VIDE:\n');
found_peaks_vide = false;
if ~isempty(fft_e_vide_filtered)
    for i = 2:length(fft_e_vide_filtered)-1
        if fft_e_vide_filtered(i) > fft_e_vide_filtered(i-1) && fft_e_vide_filtered(i) > fft_e_vide_filtered(i+1) && fft_e_vide_filtered(i) > (max(fft_e_vide_filtered)*0.1) % Seuil minimum pour éviter le bruit
            fprintf('  %.2f MHz (Amplitude : %.2e)\n', freq_vide_filtered(i) / 1e6, fft_e_vide_filtered(i));
            found_peaks_vide = true;
        end
    end
end
if ~found_peaks_vide
    fprintf('  Aucun pic significatif trouvé.\n');
end

% Cavité CHARGÉE
fprintf('Cavité CHARGÉE:\n');
found_peaks_chargee = false;
if ~isempty(fft_e_chargee_filtered)
    for i = 2:length(fft_e_chargee_filtered)-1
        if fft_e_chargee_filtered(i) > fft_e_chargee_filtered(i-1) && fft_e_chargee_filtered(i) > fft_e_chargee_filtered(i+1) && fft_e_chargee_filtered(i) > (max(fft_e_chargee_filtered)*0.1) % Seuil minimum
            fprintf('  %.2f MHz (Amplitude : %.2e)\n', freq_chargee_filtered(i) / 1e6, fft_e_chargee_filtered(i));
            found_peaks_chargee = true;
        end
    end
end
if ~found_peaks_chargee
    fprintf('  Aucun pic significatif trouvé.\n');
end

% --- Déduction sur l''influence du diélectrique ---
fprintf('\n--- Influence du diélectrique ---\n');
fprintf('Les fréquences de résonance d''une cavité sont inversement proportionnelles à la racine carrée de la permittivité effective.\n');
fprintf('L''ajout d''un matériau diélectrique (er > 1) dans la cavité augmente la permittivité effective de certaines régions.\n');
fprintf('Cela devrait entraîner une diminution des fréquences de résonance (décalage vers les basses fréquences) par rapport à la cavité vide.\n');
fprintf('De plus, l''amplitude des modes peut être affectée, et de nouveaux modes pourraient apparaître ou d''anciens disparaître, ou être atténués, en fonction de la taille, de la position et des propriétés du diélectrique.\n');
fprintf('L''analyse des spectres tracés permettra de confirmer ces hypothèses.\n');

fprintf('\nAnalyse fréquentielle et comparatif terminés. Le graphique a été généré.\n');
