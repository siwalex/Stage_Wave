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
        long=ncread(filename,'longitude');    %r�ccup�ration de la matrice des longitudes
        long=long(38:50);
        lat=ncread(filename,'latitude'); 
        lat=lat(16:28);
        %--------------------------------------------------------%

        %-----Extraire les donn�es du fichier .nc ---------------%
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
        mH2=[mH2 mH1];          %matrice moyenne hauteur 1 mois sur y ann�es

        mTp1=mean(Tp1,2);
        mTp2=[mTp2 mTp1];
    end
    mH3=mean(mH2,2);             %mean du mois 1 pour y annes
    mH4=[mH4 mH3];               %matrice moyennes des diff�rents mois
    
    mTp3=mean(mTp2,2);
    mTp4=[mTp4 mTp3];
    
end

%------Matrice de la moyenne annuelle--------------------------------%
mH5=mean(mH4,2);     %somme des puissances des moyenne mensuelles  
mH_0=reshape(mH5,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%

%------Carte-moyenne-Annuelle--------------------------------%
figure(y)
mymap=pcolor(long,lat,mH_0);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
caxis([1.2;2.5]) 
geoshow('MUS_adm0.shp','FaceColor',[.8 .8 .8])
%geoshow(S)
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Hauteur moyenne des vagues (m)');
title(tit);
set(gca,'FontSize', 15)
    s=sprintf('HTP_mau.png');
    saveas(gcf,s);
%--------------------------------------------------------%



