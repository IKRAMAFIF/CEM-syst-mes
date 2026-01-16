% tp01.m - Analyse et identification des parties du code FDTD

% Original FDTD.m code:
function [Ets]=FDTD()

% 1. Définition des constantes physiques
% Physical constants
eps0 = 8.8541878e-12;         % Permittivity of vacuum
mu0  = 4e-7 * pi;             % Permeability of vacuum
c0   = 299792458;             % Speed of light in vacuum

% 2. Initialisation des paramètres de simulation
% Parameter initiation
Lx = 3.; Ly = 3.; Lz = 3.; % Cavity dimensions in meters
Nx =  30; Ny =  30; Nz =  30; % Number of cells in each direction

Cx = Nx / Lx;                 % Inverse cell dimensions
Cy = Ny / Ly;
Cz = Nz / Lz;
Nt = 40;                     % Number of time steps
%Dt = 1/(c0*norm([Cx Cy Cz])); % Time step - commenté, utilise une valeur fixe
Dt=1e-10;

% 3. Allocation des matrices de champs et des propriétés des matériaux
% Allocate field matrices
Ex = zeros(Nx  , Ny+1, Nz+1);
Ey = zeros(Nx+1, Ny  , Nz+1);
Ez = zeros(Nx+1, Ny+1, Nz  );
Hx = zeros(Nx+1, Ny  , Nz  );
Hy = zeros(Nx  , Ny+1, Nz  );
Hz = zeros(Nx  , Ny  , Nz+1);
EPS_X = eps0*ones(Nx  , Ny+1, Nz+1);
SIGMA_X = zeros(Nx  , Ny+1, Nz+1);
EPS_Y = eps0*ones(Nx+1, Ny  , Nz+1);
SIGMA_Y = zeros(Nx+1, Ny  , Nz+1);
EPS_Z = eps0*ones(Nx+1, Ny+1, Nz  );
SIGMA_Z = zeros(Nx+1, Ny+1, Nz  );

% 4. Définition des propriétés initiales des matériaux (permittivité relative)
% Initial value : epsr
epsrx=1.0;
epsry=1.0;
epsrz=1.0;
% Insertion d'un diélectrique (objet chargé) aux coordonnées spécifiées
EPS_X(20:25,20:21,20)=epsrx*eps0;
EPS_Y(20:25,20:21,20)=epsry*eps0;
EPS_Z(20:25,20:21,20)=epsrz*eps0;

% 5. Calcul des coefficients de mise à jour des champs E
% Insertion of espilon/sigma
KE0X=(2*EPS_X-SIGMA_X*Dt)./(2*EPS_X+SIGMA_X*Dt);
KE1X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt));
%KE2X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt)); % commenté
KE0Y=(2*EPS_Y-SIGMA_Y*Dt)./(2*EPS_Y+SIGMA_Y*Dt);
KE1Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt));
%KE2Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt)); % commenté
KE0Z=(2*EPS_Z-SIGMA_Z*Dt)./(2*EPS_Z+SIGMA_Z*Dt);
KE1Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt));
%KE2Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt)); % commenté

% 6. Allocation pour le stockage des signaux temporels
% Allocate time signals
Et = zeros(Nt,3);

% 7. Définition des paramètres de la source et du point d'observation
% Initial value : input/output
xi=6; % Position x de la source
yi=6; % Position y de la source
zi=6; % Position z de la source
%t0=6.486e-9; % Ancien paramètre t0
%sigma=1.61e-9; % Ancien paramètre sigma
%nfin=71; % Ancien paramètre nfin
t0=8.761e-009; % Nouveau paramètre t0 pour la source
sigma=2e-009; % Nouveau paramètre sigma pour la source
nfin=93; % Nouveau paramètre nfin pour la source (nombre d'itérations pendant lesquelles la source est active)
% xo=15; % Ancien paramètre xo pour le point d'observation
% yo=15; % Ancien paramètre yo pour le point d'observation
% zo=15; % Ancien paramètre zo pour le point d'observation
xo=6; % Position x du point d'observation
yo=11; % Position y du point d'observation
zo=6; % Position z du point d'observation


tic
% 8. Boucle principale de simulation temporelle (Time stepping)
for n = 1:Nt;
  n % Affichage de l'itération actuelle
  
  % 9. Mise à jour des champs magnétiques (H)
  % Update H everywhere
  Hx = Hx + (Dt/mu0)*((Ey(:,:,2:Nz+1)-Ey(:,:,1:Nz))*Cz ...
                    - (Ez(:,2:Ny+1,:)-Ez(:,1:Ny,:))*Cy);
  Hy = Hy + (Dt/mu0)*((Ez(2:Nx+1,:,:)-Ez(1:Nx,:,:))*Cx ...
                    - (Ex(:,:,2:Nz+1)-Ex(:,:,1:Nz))*Cz);
  Hz = Hz + (Dt/mu0)*((Ex(:,2:Ny+1,:)-Ex(:,1:Ny,:))*Cy ...
                    - (Ey(2:Nx+1,:,:)-Ey(1:Nx,:,:))*Cx);

  % 10. Insertion de la source (si l'itération est dans la plage définie)
  % Initiate fields (near but not on the boundary)
  if (n<=nfin)
    source_ponctuelle = exp(-(n*Dt-t0)*(n*Dt-t0)/sigma/sigma); % Calcul de la valeur de la source
    Ex(xi,yi,zi) = source_ponctuelle; % Application de la source sur les champs Ex, Ey, Ez
    Ey(xi,yi,zi) = source_ponctuelle;
    Ez(xi,yi,zi) = source_ponctuelle;
  end
  
  % 11. Mise à jour des champs électriques (E) (sauf aux frontières)
  % Update E everywhere except on boundary
  Ex(:,2:Ny,2:Nz) = KE0X(:,2:Ny,2:Nz).*Ex(:,2:Ny,2:Nz) + ... %(Dt /eps0) * ...
      KE1X(:,2:Ny,2:Nz).*(Hz(:,2:Ny,2:Nz)-Hz(:,1:Ny-1,2:Nz))*Cy ...
     - KE1X(:,2:Ny,2:Nz).*(Hy(:,2:Ny,2:Nz)-Hy(:,2:Ny,1:Nz-1))*Cz;
  Ey(2:Nx,:,2:Nz) = KE0Y(2:Nx,:,2:Nz).*Ey(2:Nx,:,2:Nz) + ... %(Dt /eps0) * ...
      KE1Y(2:Nx,:,2:Nz).*(Hx(2:Nx,:,2:Nz)-Hx(2:Nx,:,1:Nz-1))*Cz ...
     - KE1Y(2:Nx,:,2:Nz).*(Hz(2:Nx,:,2:Nz)-Hz(1:Nx-1,:,2:Nz))*Cx;
  Ez(2:Nx,2:Ny,:) = KE0Z(2:Nx,2:Ny,:).*Ez(2:Nx,2:Ny,:) + ... %(Dt /eps0) * ...
      KE1Z(2:Nx,2:Ny,:).*(Hy(2:Nx,2:Ny,:)-Hy(1:Nx-1,2:Ny,:))*Cx ...
     - KE1Z(2:Nx,2:Ny,:).*(Hx(2:Nx,2:Ny,:)-Hx(2:Nx,1:Ny-1,:))*Cy;

  % 12. Échantillonnage du champ électrique au point d'observation
  % Sample the electric field at chosen points
  Ets(n,:) = [Ex(xo,yo,zo) Ey(xo,yo,zo) Ez(xo,yo,zo)];
end

toc % Fin du chronomètre
