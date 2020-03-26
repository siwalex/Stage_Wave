clear,clc

%ncdisp '2016_03.nc'
mH2=[];
mTp2=[];
for m=1:12     %boucle Annees
    filename=sprintf('2017_%.2d.nc',m);
    %----------Convertion date------------------------%
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
    mH1=mean(H1,2);
    mH2=[mH2 mH1];
    
    mTp1=mean(Tp1,2);
    mTp2=[mTp2 mTp1];
end
%--------------------------------------------------------%


%-----------Moyenne hauteur periode----------------------%
mH=mean(mH2,2);
mTp=mean(mTp2,2);
%--------------------------------------------------------%

%-------------calcul puissance moyenne------------------%
P=mH.^2.*mTp;Pw=0.4.*P;

mPw=reshape(Pw,length(lat),length(long));
%--------------------------------------------------------%

%--------Puissance dispo ds la zone ---------------------%
pw1 = Pw(~isnan(Pw));
sp=sum(pw1)/1000  % en MW/m   
%--------------------------------------------------------%

% %------Carte-moyenne-mensuelle---HI----------------------%
figure(19)
mymap=pcolor(long,lat,mPw);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
%caxis([0;90])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne houle irrégulière 2017 (kW/m)');
title(tit);
%--------------------------------------------------------%