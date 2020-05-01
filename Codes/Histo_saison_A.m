clear,clc

mH4=[];
mTp4=[];
Pwm=[];
for m=1:12     %boucle mois
    mH2=[];
    mTp2=[];
    for y=2017:2019         %boucle Annees
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
        
        mH1=mean(H1,2);         %Moyenne hauteur 1 mois
        mH2=[mH2 mH1];          %matrice moyenne hauteur 1 mois sur y années

        mTp1=mean(Tp1,2);
        mTp2=[mTp2 mTp1];
    end
    mH3=mean(mH2,2);             %mean du mois 1 pour y annes
    mH4=[mH4 mH3];               %matrice moyennes des différents mois
    
    mTp3=mean(mTp2,2);
    mTp4=[mTp4 mTp3];
    
    %-------------calcul puissance moyenne------------------%
    P=mH3.^2.*mTp3;     
    Pw=0.4.*P;
    
    Pwm=[Pwm Pw];               %matrice des puissances moyenne mensuelles
    mPw=reshape(Pw,length(lat),length(long));
    %--------------------------------------------------------%
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
h=histogram(mH12_2,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone A, de décembre à février');
title(tit);
xlabel('Hauteurs en metre')
xlim([1 2.4]);
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
yi112_2 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp12_2,25,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone A, de décembre à février');
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
yi312_2 = interp1(N, edges(index), 50);
hold off
 s=sprintf('Histo_HTp_DJF.png');
 saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf12_2=yi112_2^2.*yi312_2;
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
h=histogram(mH3_5,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone A, de mars à mai');
title(tit);
xlabel('Hauteurs en metre')
xlim([1 2.8]);
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
yi13_5 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp3_5,25,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone A, de mars à mai');
title(tit);
xlabel('Periode en s')
xlim([10 11]);
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
yi33_5 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_MAM.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf3_5=yi13_5^2.*yi33_5;
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
h=histogram(mH6_8,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone A, de juin à août');
title(tit);
xlabel('Hauteurs en metre')
xlim([1 3.5]);
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
yi16_8 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp6_8,25,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone A, de juin à août');
title(tit);
xlabel('Periode en s')
xlim([8 15]);
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
yticks(hAx(1),[0 0.125 0.25])
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
yticks(hAx(2),[0 50 100])
set(hAx,{'ycolor'},{'k';'r'})
[N, index] = unique(N); 
yi36_8 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_JJA.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------en fonction de 50% de distribution----------------%
Pf6_8=yi16_8^2.*yi36_8;
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
h=histogram(mH9_11,25,'Normalization','probability');
tit=sprintf('Distribution de la hauteur des vagues dans la zone A, de septembre à novembre');
title(tit);
xlabel('Hauteurs en metre')
xlim([1 2.8]);
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
yi19_11 = interp1(N, edges(index), 50);
hold off

%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp9_11,25,'Normalization','probability');
tit=sprintf('Distribution de la période dans la zone A, de septembre à novembre');
title(tit);
xlabel('Periode en s')
xlim([10 11]);
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
yi39_11 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_SON.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------en fonction de 50% de distribution----------------%
Pf9_11=yi19_11^2.*yi39_11;
Pwf9_11=0.4.*Pf9_11;
%--------------------------------------------------------%
