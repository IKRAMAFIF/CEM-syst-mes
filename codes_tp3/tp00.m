% tp00.m - Script pour calculer les fréquences de résonance d'une cavité parallélépipédique

% Définition des constantes physiques
c0 = 3e8; % Vitesse de la lumière dans le vide (m/s)

% Paramètres de la cavité (exemple pour la question 3 de la partie C)
a = 6.7; % Dimension x (m)
b = 8.4; % Dimension y (m)
d = 3.5; % Dimension z (m)

% Plage de modes à considérer (exemple m=n=p=5)
max_mode = 5; 

% Initialisation d'une liste pour stocker les modes viables et leurs fréquences
modes = [];

% Boucle sur les combinaisons de m, n, p
for m = 0:max_mode
    for n = 0:max_mode
        for p = 0:max_mode
            % Vérifier la condition pour un mode "viable" (au moins deux indices non nuls)
            if (m ~= 0 && n ~= 0) || (m ~= 0 && p ~= 0) || (n ~= 0 && p ~= 0)
                % Calcul de la fréquence de résonance selon l'équation (5)
                f_mnp = (c0 / 2) * sqrt((m/a)^2 + (n/b)^2 + (p/d)^2);
                modes = [modes; m, n, p, f_mnp];
            end
        end
    end
end

% Trier les modes par fréquence croissante pour trouver les 10 premiers
modes_sorted = sortrows(modes, 4);

% Afficher les 10 premiers modes de résonance viables
fprintf('Les 10 premiers modes de résonance viables (m, n, p, fréquence en Hz) :\n');
for i = 1:min(10, size(modes_sorted, 1))
    fprintf('  Mode (%d, %d, %d): %.2f Hz\n', modes_sorted(i, 1), modes_sorted(i, 2), modes_sorted(i, 3), modes_sorted(i, 4));
end
