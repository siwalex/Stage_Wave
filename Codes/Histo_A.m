clear,clc

%ncdisp '2016_03.nc'
H3=[]; 
Tp3=[]; 
for m=1:12     %boucle Annees
    H2=[];        
    Tp2=[];
    for y=2017:2019
        filename=sprintf('%d_%.2d.nc',y,m);
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
        
        H2=[H2 H1];        
        Tp2=[Tp2 Tp1];
    end
    H3=[H3 H2]; 
    Tp3=[Tp3 Tp2];    
end

%------------------Histogramme-hauteur-------------------%    
figure(13)
subplot(2,1,1)
h=histogram(H3,25,'Normalization','probability');
tit=sprintf('Distribution Annuelle de la \n hauteur des vagues en zone A');
title(tit);
xlabel('Hauteurs (m)')
xlim([0.5 , 3.5]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(H3,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
yticks(hAx(1),[0 0.125 0.25])
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
yticks(hAx(2),[0 50 100])
set(hAx,{'ycolor'},{'k';'r'}, 'FontSize', 15)
[N, index] = unique(N); 
yi1 = interp1(N, edges(index), 50);
hold off
%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(Tp3,25,'Normalization','probability');
tit=sprintf('Distribution annuelle de la période en zone A');
title(tit);
xlabel('Periode (s)')
xlim([7.5, 15]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(Tp3,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
set(hAx,{'ycolor'},{'k';'r'}, 'FontSize', 15)
[N, index] = unique(N); 
yi3 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_A.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf=yi1^2.*yi3;
Pwf=0.4.*Pf;
%--------------------------------------------------------%    
    
    