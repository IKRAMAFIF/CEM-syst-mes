% tp05_vide.m - FDTD simulation pour une cavité vide

function [Ets]=FDTD_crbm_vide()

% 1. Définition des constantes physiques
eps0 = 8.8541878e-12;         % Permittivity of vacuum
mu0  = 4e-7 * pi;             % Permeability of vacuum
c0   = 299792458;             % Speed of light in vacuum

% 2. Initialisation des paramètres de simulation
% Cavity dimensions in meters
Lx = 6.7; Ly = 8.4; Lz = 3.5; 
% Number of cells in each direction
Nx =  67; Ny =  84; Nz =  35; 

Cx = Nx / Lx;                 % Inverse cell dimensions
Cy = Ny / Ly;
Cz = Nz / Lz;
Nt = 400;                     % Number of time steps
Dt=1e-10;

% 3. Allocation des matrices de champs et des propriétés des matériaux
Ex = zeros(Nx  , Ny+1, Nz+1);
Ey = zeros(Nx+1, Ny  , Nz+1);
Ez = zeros(Nx+1, Ny+1, Nz  );
Hx = zeros(Nx+1, Ny  , Nz  );
Hy = zeros(Nx  , Ny+1, Nz  );
Hz = zeros(Nx  , Ny  , Nz+1);
% Cavité VIDE : Toutes les permittivités sont celles du vide
EPS_X = eps0*ones(Nx  , Ny+1, Nz+1);
SIGMA_X = zeros(Nx  , Ny+1, Nz+1);
EPS_Y = eps0*ones(Nx+1, Ny  , Nz+1);
SIGMA_Y = zeros(Nx+1, Ny  , Nz+1);
EPS_Z = eps0*ones(Nx+1, Ny+1, Nz  );
SIGMA_Z = zeros(Nx+1, Ny+1, Nz  );

% AUCUNE insertion diélectrique spécifique pour le cas vide

% 5. Calcul des coefficients de mise à jour des champs E
KE0X=(2*EPS_X-SIGMA_X*Dt)./(2*EPS_X+SIGMA_X*Dt);
KE1X=((2*Dt)./(2*EPS_X+SIGMA_X*Dt));
KE0Y=(2*EPS_Y-SIGMA_Y*Dt)./(2*EPS_Y+SIGMA_Y*Dt);
KE1Y=((2*Dt)./(2*EPS_Y+SIGMA_Y*Dt));
KE0Z=(2*EPS_Z-SIGMA_Z*Dt)./(2*EPS_Z+SIGMA_Z*Dt);
KE1Z=((2*Dt)./(2*EPS_Z+SIGMA_Z*Dt));

% 6. Allocation pour le stockage des signaux temporels
Ets = zeros(Nt,3); % Renommé pour correspondre à la sortie de la fonction

% 7. Définition des paramètres de la source et du point d'observation
xi=6; 
 yi=6; 
 zi=6; 
 t0=8.761e-009; 
 sigma=2e-009; 
 nfin=93; 
 xo=6; 
 yo=11; 
 zo=6; 

toc
% 8. Boucle principale de simulation temporelle (Time stepping)
for n = 1:Nt;
  % n % Commenté pour éviter un affichage trop verbeux
  
  % 9. Mise à jour des champs magnétiques (H)
  Hx = Hx + (Dt/mu0)*((Ey(:,:,2:Nz+1)-Ey(:,:,1:Nz))*Cz ...
                    - (Ez(:,2:Ny+1,:)-Ez(:,1:Ny,:))*Cy);
  Hy = Hy + (Dt/mu0)*((Ez(2:Nx+1,:,:)-Ez(1:Nx,:,:))*Cx ...
                    - (Ex(:,:,2:Nz+1)-Ex(:,:,1:Nz))*Cz);
  Hz = Hz + (Dt/mu0)*((Ex(:,2:Ny+1,:)-Ex(:,1:Ny,:))*Cy ...
                    - (Ey(2:Nx+1,:,:)-Ey(1:Nx,:,:))*Cx);

  % 10. Insertion de la source (si l'itération est dans la plage définie)
  if (n<=nfin)
    source_ponctuelle = exp(-(n*Dt-t0)*(n*Dt-t0)/sigma/sigma); 
    Ex(xi,yi,zi) = source_ponctuelle; 
    Ey(xi,yi,zi) = source_ponctuelle;
    Ez(xi,yi,zi) = source_ponctuelle;
  end
  
  % 11. Mise à jour des champs électriques (E) (sauf aux frontières)
  Ex(:,2:Ny,2:Nz) = KE0X(:,2:Ny,2:Nz).*Ex(:,2:Ny,2:Nz) + ...
      KE1X(:,2:Ny,2:Nz).*(Hz(:,2:Ny,2:Nz)-Hz(:,1:Ny-1,2:Nz))*Cy ...
     - KE1X(:,2:Ny,2:Nz).*(Hy(:,2:Ny,2:Nz)-Hy(:,2:Ny,1:Nz-1))*Cz;
  Ey(2:Nx,:,2:Nz) = KE0Y(2:Nx,:,2:Nz).*Ey(2:Nx,:,2:Nz) + ...
      KE1Y(2:Nx,:,2:Nz).*(Hx(2:Nx,:,2:Nz)-Hx(2:Nx,:,1:Nz-1))*Cz ...
     - KE1Y(2:Nx,:,2:Nz).*(Hz(2:Nx,:,2:Nz)-Hz(1:Nx-1,:,2:Nz))*Cx;
  Ez(2:Nx,2:Ny,:) = KE0Z(2:Nx,2:Ny,:).*Ez(2:Nx,2:Ny,:) + ...
      KE1Z(2:Nx,2:Ny,:).*(Hy(2:Nx,2:Ny,:)-Hy(1:Nx-1,2:Ny,:))*Cx ...
     - KE1Z(2:Nx,2:Ny,:).*(Hx(2:Nx,2:Ny,:)-Hx(2:Nx,1:Ny-1,:))*Cy;

  % 12. Echantillonnage du champ electrique au point d'observation
  Ets(n,:) = [Ex(xo,yo,zo) Ey(xo,yo,zo) Ez(xo,yo,zo)];
end

toc 

% 13. Sauvegarde des résultats
output_file = 'TP3_solution/result_vide.txt'; % Nom de fichier ajusté
dlmwrite(output_file, Ets, 'delimiter', ' ');
fprintf('Résultats du champ électrique (cavité vide) sauvegardés dans %s\n', output_file);

end % Fin de la fonction
