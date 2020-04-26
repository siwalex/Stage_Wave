clear,clc

%ncdisp '2016_03.nc'
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
        long=long(38:50);
        lat=ncread(filename,'latitude'); 
        lat=lat(16:28);
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        H0=H0(38:50,16:28,:);
        Tp0=ncread(filename,'VTPK');      %Peak period
        Tp0=Tp0(38:50,16:28,:);
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

mH12=[];
mTp12=[];
for i=12
   mH5=mH4(:,i);
   mH12=[mH12 mH5];
   
   mTp5=mTp4(:,i);
   mTp12=[mTp12 mTp5];
end

mH1_2=[];
mTp1_2=[];
for i=1:2
   mH5=mH4(:,i);
   mH1_2=[mH1_2 mH5];
   
   mTp5=mTp4(:,i);
   mTp1_2=[mTp1_2 mTp5];
end
%%
mH12_2=[mH12 mH1_2]; %matrice décembre + janvier février
mTp12_2=[mTp12 mTp1_2];
%------------------Histogramme-hauteur-------------------%    
figure(1)
subplot(2,1,1)
h=histogram(mH12_2,50,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone C, de décembre à février');
title(tit);
xlabel('Hauteurs en metre')
xlim([0.8 2.3]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH12_2,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi51 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp12_2,50,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone C, de décembre à février');
title(tit);
xlabel('Periode en s')
xlim([8.2 13.2]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp12_2,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi52 = interp1(N, edges(index), 50);
hold off
 s=sprintf('Histo_HTp_DJF_mau.png');
 saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf12_2=yi51^2.*yi52;
Pwf12_2=0.4.*Pf12_2;
%--------------------------------------------------------%

%---------------------------------------------------------------------------------------------------------%
%---------------------------------------------------------------------------------------------------------%
mH3_5=[];
mTp3_5=[];
for i=3:5
   mH6=mH4(:,i);
   mH3_5=[mH3_5 mH6];
   
   mTp6=mTp4(:,i);
   mTp3_5=[mTp3_5 mTp6];
end

%------------------Histogramme-hauteur-------------------%    
figure(2)
subplot(2,1,1)
h=histogram(mH3_5,50,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone C, de mars à mai');
title(tit);
xlabel('Hauteurs en metre')
xlim([1.3 2.6]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH3_5,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi61 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp3_5,50,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone C, de mars à mai');
title(tit);
xlabel('Periode en s')
xlim([8.9 14]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp3_5,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi62 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_MAM_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf3_5=yi61^2.*yi62;
Pwf3_5=0.4.*Pf3_5;
%--------------------------------------------------------%


%--------------------------------------------------------------------------------------------------------%
 
mH6_8=[];
mTp6_8=[];
for i=6:8
   mH7=mH4(:,i);
   mH6_8=[mH6_8 mH7];
   
   mTp7=mTp4(:,i);
   mTp6_8=[mTp6_8 mTp7];
end

%------------------Histogramme-hauteur-------------------%    
figure(3)
subplot(2,1,1)
h=histogram(mH6_8,50,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone C, de juin à août');
title(tit);
xlabel('Hauteurs en metre')
xlim([1.5 3.1]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH6_8,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi71 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp6_8,50,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone C, de juin à août');
title(tit);
xlabel('Periode en s')
xlim([8.9 15]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp6_8,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi72 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_JJA_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------en fonction de 50% de distribution----------------%
Pf6_8=yi71^2.*yi72;
Pwf6_8=0.4.*Pf6_8;
%--------------------------------------------------------%

%--------------------------------------------------------------------------------------------------------%
mH9_11=[];
mTp9_11=[];
for i=9:11
   mH8=mH4(:,i);
   mH9_11=[mH9_11 mH8];
   
   mTp8=mTp4(:,i);
   mTp9_11=[mTp9_11 mTp8];
end

%------------------Histogramme-hauteur-------------------%    
figure(4)
subplot(2,1,1)
h=histogram(mH9_11,50,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone C, de septembre à novembre');
title(tit);
xlabel('Hauteurs en metre')
xlim([1 2.5]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH9_11,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi81 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp9_11,50,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone C, de septembre à novembre');
title(tit);
xlabel('Periode en s')
xlim([8.5 14]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp9_11,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi82 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_SON_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------en fonction de 50% de distribution----------------%
Pf9_11=yi81^2.*yi82;
Pwf9_11=0.4.*Pf9_11;
%--------------------------------------------------------%