% Resolution equation de Laplace
%
clear
close all
clc

%% Dimensions / maillage
dx=1; % cm
dy=1; % cm
Nx = 40 ;
Ny = 40;

%% Potentiels / sources
v0 =0 ; % condition aux limites (en V)
v1 = 100; % conducteur 1
v2 = -100 ; % conducteur 2

% Initialisation la matrice de calcul
V = zeros(Nx,Ny); % mettre toute la matrice a zero
%condition aux limites
for j=1:Ny;
V(1,j)=v0;
V(Nx,j)=v0;
end
for i=1:Nx;
V(i,1)=v0;
V(i,Ny)=v0;
end
% Potentiel conducteur1

i=8:35; j=25:28;
  V(i,j)=v1;

%potentiel conducteur 2
i=20:21;j=5:22;
  V(i,j)=v2;

%% Boucle pour itérer le processus 200 fois

% Equation de calcul
%i=1;j=1;
%V(i,j)=...
i=2:Nx-1;
j=2:Ny-1;
V(i,j)=0.25*(V(i+1,j)+V(i-1,j)+V(i,j+1)+V(i,j-1));
%potentiel v1 sur conducteur 1
i=8:35; j=25:28;
    V(i,j)=v1;

%potentiel v1 sur conducteur 2
i=20:21;j=5:22;
     V(i,j)=v2;
% Figure
figure;
pcolor(V')
colormap jet
axis equal
