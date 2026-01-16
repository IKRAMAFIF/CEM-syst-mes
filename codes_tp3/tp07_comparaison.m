% tp07_comparaison.m - Visualisation comparative des résultats temporels

% Paramètres temporels
Dt = 1e-10; % Pas de temps
Nt = 400;   % Nombre d'itérations temporelles

% Création du vecteur temps
t = (0:Nt-1) * Dt;

% --- Chargement des données ---
try
    data_vide = load('TP3_solution/result_vide.txt');
    data_chargee = load('TP3_solution/result_chargee.txt');
catch
    error('Les fichiers result_vide.txt et/ou result_chargee.txt n''ont pas été trouvés. Veuillez d''abord exécuter tp06.m.');
end

% --- Création de la figure comparative ---
figure;

% Premier sous-graphique : Superposition des signaux Ex
subplot(2, 1, 1); % Divise la figure en 2 lignes, 1 colonne, et sélectionne la 1ère position
plot(t, data_vide(:,1), 'b', 'DisplayName', 'Ex (Vide)');
hold on;
plot(t, data_chargee(:,1), 'r--', 'DisplayName', 'Ex (Chargée)');
hold off;
title('Superposition des Champs Temporels (Composante Ex)');
xlabel('Temps (s)');
ylabel('Amplitude');
legend('show');
grid on;

% Deuxième sous-graphique : Différence entre les signaux
subplot(2, 1, 2); % Sélectionne la 2ème position
difference = data_vide(:,1) - data_chargee(:,1);
plot(t, difference, 'k', 'DisplayName', 'Différence (Vide - Chargée)');
title('Différence entre les signaux Ex');
xlabel('Temps (s)');
ylabel('Amplitude de la différence');
legend('show');
grid on;

fprintf('Le graphique comparatif a été généré.\n');

