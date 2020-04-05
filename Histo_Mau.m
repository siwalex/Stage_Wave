clear,clc

mH4=[];
mTp4=[];
Pwm=[];
for m=1:12     %boucle Annees
    mH2=[];
    mTp2=[];
    for y=2017:2019
        filename=sprintf('%d_%.2d.nc',y,m);
        %----------Convertion date------------------------%
         t=ncread(filename,'time');
%         date=datetime(1950, 1, 1, t, 0, 0);
        %-------------------------------------------------%

        %-----Extraire longitude latitute ---------------%
        long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
        long=long(14:27);
        lat=ncread(filename,'latitude'); 
        lat=lat(6:19);
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        H0=H0(14:27,6:19,:);
        Tp0=ncread(filename,'VTPK');      %Peak period
        Tp0=Tp0(14:27,6:19,:);
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
        
        mH1=mean(H1,2);         %Moyenne hauteur 1 mois
        mH2=[mH2 mH1];          %matrice moyenne 1 mois sur y années

        mTp1=mean(Tp1,2);
        mTp2=[mTp2 mTp1];
    end
    mH3=mean(mH2,2);             %mean du mois 1 pour y annes
    
    mTp3=mean(mTp2,2);
    
    mH4=[mH4 mH3];
    mTp4=[mTp4 mTp3];    
end

    
%------------------Histogramme-hauteur-------------------%    
figure(14)
h=histogram(mH4,50,'Normalization','probability');
tit=sprintf('Distribution hauteur des vagues sur toute la zone');
title(tit);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH4,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
plotyy(0,0,edges,N)
[N, index] = unique(N); 
yi1 = interp1(N, edges(index), 50);
hold off
%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
figure(15)
h=histogram(mTp4,50,'Normalization','probability');
tit=sprintf('Distribution de la période sur toute la zone');
title(tit);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp4,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
plotyy(0,0,edges,N)
[N, index] = unique(N); 
yi3 = interp1(N, edges(index), 50);
hold off
%--------------------------------------------------------%

%------Puissance moyenne-------------%
Pf=yi1^2.*yi3;
Pwf=0.4.*Pf;
%------------------------------------%    
    
    