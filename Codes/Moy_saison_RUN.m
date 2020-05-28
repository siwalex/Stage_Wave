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

sPw10=[];
for i=12
   sPw0=Pwm(:,i);
   sPw10=[sPw10 sPw0];
end

sPw11=[];
for i=1:2
   sPw1=Pwm(:,i);
   sPw11=[sPw11 sPw1];
end

sPw101=[sPw10 sPw11]; %matrice décembre + janvier février
%------Matrice de la moyenne annuelle--------------------------------%
yPw1=mean(sPw101,2);     %somme des puissances des moyenne mensuelles  
ymPw1=reshape(yPw1,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%
%------Carte-moyenne-Annuelle--------------------------------%
figure(13)
mymap=pcolor(long,lat,ymPw1);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
caxis([0;45])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne de decembre à \n février (kW/m), en zone B');
title(tit);
set(gca,'FontSize', 15)
geoshow('run_adm0.shp','FaceColor',[.8 .8 .8])
s=sprintf('PMSais_DJF_RUN.png');
saveas(gcf,s);
%--------------------------------------------------------%
%%
sPw22=[];
for i=3:5
   sPw2=Pwm(:,i);
   sPw22=[sPw22 sPw2];
end

%------Matrice de la moyenne annuelle--------------------------------%
yPw2=mean(sPw22,2);     %somme des puissances des moyenne mensuelles  
ymPw2=reshape(yPw2,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%
%------Carte-moyenne-Annuelle--------------------------------%
figure(14)
mymap=pcolor(long,lat,ymPw2);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
caxis([0;45])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne de mars à \n mai (kW/m), en zone B');
title(tit);
set(gca,'FontSize', 15)
geoshow('run_adm0.shp','FaceColor',[.8 .8 .8])
   s=sprintf('PMSais_MAM_RUN.png');
   saveas(gcf,s);
%--------------------------------------------------------%

sPw33=[];
for i=6:8
   sPw3=Pwm(:,i);
   sPw33=[sPw33 sPw3];
end

%------Matrice de la moyenne annuelle--------------------------------%
yPw3=mean(sPw33,2);     %somme des puissances des moyenne mensuelles  
ymPw3=reshape(yPw3,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%
%------Carte-moyenne-Annuelle--------------------------------%
figure(15)
mymap=pcolor(long,lat,ymPw3);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
caxis([0;45])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne de juin à \n aout (kW/m), en zone B');
title(tit);
set(gca,'FontSize', 15)
geoshow('run_adm0.shp','FaceColor',[.8 .8 .8])
   s=sprintf('PMSais_JJA_RUN.png');
   saveas(gcf,s);
%--------------------------------------------------------%

sPw44=[];
for i=9:11
   sPw4=Pwm(:,i);
   sPw44=[sPw44 sPw4];
end
%------Matrice de la moyenne annuelle--------------------------------%
yPw4=mean(sPw44,2);     %somme des puissances des moyenne mensuelles  
ymPw4=reshape(yPw4,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%
%------Carte-moyenne-Annuelle--------------------------------%
figure(16)
mymap=pcolor(long,lat,ymPw4);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
caxis([0;45])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne de Septembre à \n Novembre (kW/m), en zone B');
title(tit);
set(gca,'FontSize', 15)
geoshow('run_adm0.shp','FaceColor',[.8 .8 .8])
   s=sprintf('PMSais_SON_RUN.png');
   saveas(gcf,s);
%--------------------------------------------------------%

