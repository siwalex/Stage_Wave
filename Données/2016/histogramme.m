clc,clear

%-----Extraire les données du fichier .nc ---------------%
% filename='2016_03.nc';
% 
% long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
% lat=ncread(filename,'latitude');
% H0=ncread(filename,'VHM0');
% Tp=ncread(filename,'VTPK');      %Peak period
% t=ncread(filename,'time');
% vmdr=ncread(filename,'VMDR_WW');
% vped=ncread(filename,'VPED');

for m=3:12
    f=sprintf('2016_%.2d.nc',m);
    filename=f;
    
    

long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
lat=ncread(filename,'latitude');
H0=ncread(filename,'VHM0');
Tp=ncread(filename,'VTPK');      %Peak period
t=ncread(filename,'time');
vmdr=ncread(filename,'VMDR_WW');
vped=ncread(filename,'VPED');
    
    
figure(1)
caxis([0;0.35]);
h=histogram(H0,50,'Normalization','probability');
tit=sprintf('Distribution hauteur vague du %.2d',m);
title(tit);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(H0,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
plotyy(0,0,edges,N)
interp1(N, edges, 50);
hold off

figure(3)
caxis([0;0.35]);
h=histogram(Tp,50,'Normalization','probability');
tit=sprintf('Distribution de la période du %.2d',m);
title(tit);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(Tp,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
plotyy(0,0,edges,N)
interp1(N, edges, 50);
hold off

figure(2)
v=[];
for i=1:length(t)
v1=vmdr(1,1,i);
v=[v v1];
end

polar(0,50,'-k')
tit=sprintf('Distribution (poucentage) direction du vent du %.2d',m);
title(tit);
hold on
theta = v.*pi/180;
[tout, rout] = rose2Relative(theta);
polar(tout, rout);
hold off


% figure(3)
% t=histogram(vped,100,'Normalization','probability')
% hold on
% % comptage sur 100 casiers
% [M,edges2]  = histcounts(vped,100);
% M(M==0)=1;
% % valeur moyenne des casiers
% edges2 = (edges2(1:end-1)+edges2(2:end))/2;
% % N en cumulé et pourcentage
% M = cumsum(M)/sum(M)*100;
% % affichage
% plotyy(0,0,edges2,M)
% interp1(M, edges2, 50)

figure(4)
b=[];
for j=1:length(t)
b1=vped(1,1,j);
b=[b b1];
end

polar(0,50,'-k')
tit=sprintf('Distribution (poucentage) direction pique des vagues du %.2d',m);
title(tit);
hold on
theta2 = b.*pi/180;
[tout2, rout2] = rose2Relative(theta2);
polar(tout2, rout2);
hold off

end


% figure(2)
% h2=histogram(Tp,20,'Normalization','probability')
% hold on
% % comptage sur 100 casiers
% 
% [N2,edges2]  = histcounts(Tp,100);
% % remplace les valeures nulles pour l'interpolation
% N2(N2==0)=1;
% % % valeur moyenne des casiers
% edges2 = (edges2(1:end-1)+edges2(2:end))/2;
% % % N en cumulé et pourcentage
% N2 = cumsum(N2)/sum(N2)*100;
% % % affichage
% plotyy(0,0,edges2,N2);
% interp1(N2, edges2, 50)
