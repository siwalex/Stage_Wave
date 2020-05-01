clear,clc

%ncdisp '2016_03.nc'

%----------Convertion date---------------%
clear,clc
filename='2017_03.nc';
t=ncread(filename,'time');
date=datetime(1950, 1, 1, t, 0, 0);
%-------------------------------------------------%

%-----Extraire longitude latitute ---------------%
long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
lat=ncread(filename,'latitude'); 
%--------------------------------------------------------%

%-----Extraire les données du fichier .nc ---------------%
H0=ncread(filename,'VHM0');     %Hauteur
Tp0=ncread(filename,'VTPK');      %Peak period
H1=[];
Tp1=[];
for i=1:length(t)
    H=H0(:,:,i);
    H=H';
    H=H(:);
    H1=[H1 H];

    Tp=Tp0(:,:,i);
    Tp=Tp';
    Tp=Tp(:);
    Tp1=[Tp1 Tp];
end
%--------------------------------------------------------%


%-----------Moyenne hauteur periode----------------------%
mH=mean(H1,2);
mTp=mean(Tp1,2);
%--------------------------------------------------------%

 %-------------calcul puissance moyenne------------------%
P=mH.^2.*mTp;
Pw=0.4.*P;

mPw=reshape(Pw,length(lat),length(long));
%--------------------------------------------------------%


% %------Carte-moyenne-mensuelle---HI----------------------%
figure(2)
mymap=pcolor(long,lat,mPw);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
%caxis([0;70])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne houle irrégulière mars 2016');
title(tit);
%--------------------------------------------------------%



