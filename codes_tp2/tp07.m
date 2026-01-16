% tp07.m - Visualisation des résultats temporels des simulations FDTD

% Paramètres temporels (doivent correspondre à ceux utilisés dans les simulations FDTD)
Dt = 1e-10; % Pas de temps
Nt = 400;   % Nombre d'itérations temporelles

% Création du vecteur temps
t = (0:Nt-1) * Dt;

% --- Cavité VIDE ---
% Chargement des résultats
data_vide = load('TP3_solution/result_vide.txt');

% Tracé des composantes du champ électrique pour la cavité vide
figure;
plot(t, data_vide(:,1), 'r', 'DisplayName', 'Ex');
hold on;
plot(t, data_vide(:,2), 'g', 'DisplayName', 'Ey');
plot(t, data_vide(:,3), 'b', 'DisplayName', 'Ez');
hold off;
title('Champ Électrique Temporel (Cavité VIDE)');
xlabel('Temps (s)');
ylabel('Amplitude du Champ Électrique');
legend('show');
grid on;

% --- Cavité CHARGÉE ---
% Chargement des résultats
data_chargee = load('TP3_solution/result_chargee.txt');

% Tracé des composantes du champ électrique pour la cavité chargée
figure;
plot(t, data_chargee(:,1), 'r', 'DisplayName', 'Ex');
hold on;
plot(t, data_chargee(:,2), 'g', 'DisplayName', 'Ey');
plot(t, data_chargee(:,3), 'b', 'DisplayName', 'Ez');
hold off;
title('Champ Électrique Temporel (Cavité CHARGÉE)');
xlabel('Temps (s)');
ylabel('Amplitude du Champ Électrique');
legend('show');
grid on;

fprintf('Les graphiques des champs électriques temporels ont été générés.\n');
