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
        long=ncread(filename,'longitude');    %r�ccup�ration de la matrice des longitudes
        long=long(14:27);
        lat=ncread(filename,'latitude'); 
        lat=lat(6:19);
        %--------------------------------------------------------%

        %-----Extraire les donn�es du fichier .nc ---------------%
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
    
%------------------Histogramme-hauteur-------------------%    
figure(14)
subplot(2,1,1)
h=histogram(H3,25,'Normalization','probability');
tit=sprintf('Distribution annuelle de la \n hauteur des vagues en zone B');
title(tit);
%xlim([1, 3.5]);
xlabel('Hauteurs (m)')
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(H3,100);
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumul� et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fr�quence ') % left y-axis 
ylabel(hAx(2),'Fr�quence cumul�e (%)') % right y-axis
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi1 = interp1(N, edges(index), 50);
hold off
%--------------------------------------------------------%

%------------------Histogramme-Periode-------------------%
subplot(2,1,2)
h=histogram(Tp3,25,'Normalization','probability');
tit=sprintf('Distribution annuelle de la p�riode zone B');
title(tit);
%xlim([8, 15]);
xlabel('Periode (s)')
hold on
% comptage sur 100 casiers
[N,edges]  = histcounts(Tp3,100);
N(N==0)=1;
% valeur moyenne des casiers
edges = (edges(1:end-1)+edges(2:end))/2;
% N en cumul� et pourcentage
N = cumsum(N)/sum(N)*100;
% affichage
[hAx,~,~]=plotyy(0,0,edges,N);
ylabel(hAx(1),'Fr�quence ') % left y-axis 
ylabel(hAx(2),'Fr�quence cumul�e (%)') % right y-axis
set(hAx,{'ycolor'},{'k';'r'},'FontSize', 15)
[N, index] = unique(N); 
yi3 = interp1(N, edges(index), 50);
hold off
s=sprintf('Histo_A_run.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------Puissance moyenne-------------%
Pf=yi1^2.*yi3;
Pwf=0.4.*Pf;
%------------------------------------%    
    
    