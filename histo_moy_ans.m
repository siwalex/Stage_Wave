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
        mH2=[mH2 mH1];          %matrice moyenne 1 mois sur y années

        mTp1=mean(Tp1,2);
        mTp2=[mTp2 mTp1];
    end
    mH3=mean(mH2,2);             %mean du mois 1 pour y annes
    
    mTp3=mean(mTp2,2);
    
    mH4=[mH4 mH3];
    mTp4=[mTp4 mTp3];
    
    %-------------calcul puissance moyenne------------------%
    P=mH3.^2.*mTp3;
    Pw=0.4.*P;
    
    Pwm=[Pwm Pw];
    mPw=reshape(Pw,length(lat),length(long));
    %--------------------------------------------------------%
    
end
%%    
%------------------Histogramme-hauteur-------------------%    
figure(13)
subplot(2,1,1)
h=histogram(mH4,20,'Normalization','probability');
tit=sprintf('Distribution Annuelle de la hauteur des vagues sur toute la zone');
title(tit);
xlabel('Hauteurs en metre')
%ylabel('Fréquence')
%yylabel('Fréquence en %')

hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mH4,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumulé et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fréquence ') % left y-axis 
ylabel(hAx(2),'Fréquence cumulé en %') % right y-axis
set(hAx,{'ycolor'},{'k';'r'})
xlim([1 , 3.5]);
[N, index] = unique(N); 
yi1 = interp1(N, edges(index), 50);
hold off
%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(mTp4,20,'Normalization','probability');
tit=sprintf('Distribution annuelle de la période sur toute la zone');
title(tit);
xlabel('Periode en s')
%ylabel('Fréquence')
xlim([8, 15]);
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(mTp4,100);
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
yi3 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_HTp_MA.png');
saveas(gcf,s);
%--------------------------------------------------------%

%----calcul de la puissance moyenne annuel---------------%
%------en fonction de 50% de distribution----------------%
Pf=yi1^2.*yi3;
Pwf=0.4.*Pf;
%--------------------------------------------------------%    
    
    