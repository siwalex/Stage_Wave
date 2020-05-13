clear,clc

H3=[];
Tp3=[];
for m=1:12     %boucle Annees
    H2=[];
    Tp2=[];
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
        H2=[H2 H1];        
        Tp2=[Tp2 Tp1];
    end
    H3=[H3 H2]; 
    Tp3=[Tp3 Tp2];    
end

H5_10=H3(:,2881:7288);
Tp5_10=Tp3(:,2881:7288);

%------------------Histogramme-hauteur-------------------%    
figure(2)
subplot(2,1,1)
h=histogram(H5_10,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues \n dans la zone B, de mai à octobre');
title(tit);
xlabel('Hauteur (m)')
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(H5_10,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
yticks(hAx(1),[0 0.05 0.1])
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
yticks(hAx(2),[0 50 100])
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi1 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(Tp5_10,25,'Normalization','probability');
tit=sprintf('Distribution de la période \n dans la zone B, de mai à octobre');
title(tit);
xlabel('Periode (s)')
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(Tp5_10,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
yticks(hAx(1),[0 0.1 0.2])
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
yticks(hAx(2),[0 50 100])
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi3 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_hivers_run.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf5_10=yi1^2.*yi3;
Pwf3_5=0.4.*Pf5_10;
%--------------------------------------------------------%

%------------------été-------------------------%
H11_12=H3(:,8008:8752);
Tp11_12=Tp3(:,8008:8752);

H1_4=H3(:,1:2880);
Tp1_4=Tp3(:,1:2880);

H12_4=[];
H12_4=[H11_12 H1_4];

Tp12_4=[];
Tp12_4=[Tp11_12 Tp1_4];

%------------------Histogramme-hauteur-------------------%    
figure(1)
subplot(2,1,1)
h=histogram(H12_4,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues \n dans la zone B, de novembre à avril');
title(tit);
xlabel('Hauteur (m)')
xlim([1 2.4]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(H12_4,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi12 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(Tp12_4,25,'Normalization','probability');
tit=sprintf('Distribution de la période \n dans la zone B, de novembre à avril');
title(tit);
xlabel('Periode (s)')
xlim([8.2 13.2]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(Tp12_4,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulée (%)') % right y-axis
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi32 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_ete_run.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf11_4=yi12^2.*yi32;
Pwf11_4=0.4.*Pf11_4;
%--------------------------------------------------------%



