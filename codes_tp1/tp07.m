% Resolution equation de Laplace
%
clear
close all
clc

%% Dimensions / maillage
dx = 1;   % cm
dy = 1;   % cm
Nx = 40;
Ny = 40;

%% Potentiels / sources
v0 = 0;      % condition aux limites (en V)
v1 = 100;    % conducteur 1
v2 = -100;   % conducteur 2

% Initialisation la matrice de calcul
V = zeros(Nx,Ny); % mettre toute la matrice a zero

% Bords
j = 1:Ny; V(1,j) = v0; V(Nx,j) = v0;
i = 1:Nx; V(i,1) = v0; V(i,Ny) = v0;

% Conducteurs
i = 8:34;  j = 25:28; V(i,j) = v1;   % Potentiel conducteur 1
i = 20:21; j = 5:22;  V(i,j) = v2;   % Potentiel conducteur 2

%% Critere de convergence
seuil_convergence = 1e-2;
erreur = 1e6;
k = 0;
max_iter = 1000;

% Boucle d'iteration (Jacobi)
while (erreur > seuil_convergence) && (k < max_iter)
    k = k + 1;
    V_old = V;

    % Calcul dans tout l'interieur du domaine
    i = 2:Nx-1; j = 2:Ny-1;
    V(i,j) = 0.25*( V(i+1,j) + V(i-1,j) + V(i,j-1) + V(i,j+1) );

    % Reimposer les conducteurs (et donc leurs potentiels)
    i = 8:34;  j = 25:28; V(i,j) = v1;
    i = 20:21; j = 5:22;  V(i,j) = v2;

    % Erreur max entre deux iterations
    erreur = max(max(abs(V - V_old)));
end
disp(['Nombre total d''iterations pour convergence (Seuil = ', num2str(seuil_convergence), '): ', num2str(k)]);

%% Calcul du champ electrique (E = -grad(V))
% pas en metres (eps0 est en F/m)
dx_m = dx*1e-2;
dy_m = dy*1e-2;

% gradient(F,dy,dx) -> renvoie [dF/dy, dF/dx] avec espacements
[Vy, Vx] = gradient(V, dy_m, dx_m);  % Vy = dV/dy, Vx = dV/dx (unites V/m)
Ex = -Vx;    % composante x du champ (V/m)
Ey = -Vy;    % composante y du champ (V/m)

%% Calcul de la charge et de la capacite (contour a 1 maille)
eps0 = 8.854e-12;  % F/m

% Indices du conducteur 1
i1 = 8:34;
j1 = 25:28;

% Contour autour du conducteur
i_min = min(i1)-1; i_max = max(i1)+1;
j_min = min(j1)-1; j_max = max(j1)+1;

ds = dx_m;  % longueur d'un segment (m)

Q1 = 0;

% Bord superieur (normal +y)
j = j_max + 1;
for i = i1
    Q1 = Q1 + Ey(i,j)*ds;
end

% Bord inferieur (normal -y)
j = j_min - 1;
for i = i1
    Q1 = Q1 - Ey(i,j)*ds;
end

% Bord gauche (normal -x)
i = i_min - 1;
for j = j1
    Q1 = Q1 - Ex(i,j)*ds;
end

% Bord droit (normal +x)
i = i_max + 1;
for j = j1
    Q1 = Q1 + Ex(i,j)*ds;
end

% Charge totale et capacite
Q1 = eps0 * Q1;                 % Coulomb
C  = abs(Q1) / abs(v1 - v2);    % Farad

fprintf('\nCharge sur conducteur 1 : Q1 = %e C\n', Q1);
fprintf('Capacite C = %e F\n', C);

%% Figures
figure;
quiver(Ex', Ey'); hold on
contour(V');
colormap jet
axis equal

