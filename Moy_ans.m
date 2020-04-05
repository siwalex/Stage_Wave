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
    
    %------Carte-moyenne-mensuelle--------------------------------%
    figure(m)
    mymap=pcolor(long,lat,mPw);      %creer une map 
    mymap.EdgeAlpha=0;              %taille du maillage
    colormap(jet)                   %legend
    colorbar;             
    %caxis([0;60])    
    xlabel('Longitude')
    ylabel('Latitude')
    tit=sprintf('Puissance moyenne mensuelle pour le %.2d (kW/m)',m);
    title(tit);
        s=sprintf('PMA_%d.png',y);
        saveas(gcf,s);
    %--------------------------------------------------------%
end

%------Matrice de la moyenne annuelle--------------------------------%
yPw=sum(Pwm,2);     %somme des puissances des moyenne mensuelles  
ymPw=reshape(yPw,length(lat),length(long));     %redimensionne
%--------------------------------------------------------%

%------Carte-moyenne-Annuelle--------------------------------%
figure(y)
mymap=pcolor(long,lat,ymPw);      %creer une map 
mymap.EdgeAlpha=0;              %taille du maillage
colormap(jet)                   %legend
colorbar;             
%caxis([40;400])    
xlabel('Longitude')
ylabel('Latitude')
tit=sprintf('Puissance moyenne annuelle sur 3 ans');
title(tit);
    s=sprintf('PMA_%d.png',y);
    saveas(gcf,s);
%--------------------------------------------------------%



