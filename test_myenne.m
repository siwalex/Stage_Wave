clear,clc
%-----Extraire-donnees+moyennes---------------%
P2=[];
for m=3:12     %boucle Annees
    %try
    Hp=[];
    T=[];
    h=[];
    H1=[];
    P1=[];
    for y=2016:2017      %boucle mois
        f=sprintf('%.d_%.2d.nc',y,m);
        filename=f;
        long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
        lat=ncread(filename,'latitude');
        H0=ncread(filename,'VHM0');         % hauteur
        t=ncread(filename,'time');
        Tp=ncread(filename,'VTPK');      %Peak period
        
        R=1.025;        %Kg/m^3
        g=9.81;
        c=(1/4)*R*g;
        P0=[];
        for i=1:length(t)   %chaque timestamp
            %-------calcul des puissances des .nc--------------------%
            H1=H0(:,:,i);
            H1=H1';              %Hauteur 
            T1=Tp(:,:,i);
            T1=T1';              %Periode
            v=g.*T1/(2*pi);      %Vitesse
            P=c.*H1.^2.*v;       %Puissance
            te=t(i);
            %-------------------------------------------------------%
            P=P(:);
            P0=[P0 P];
            
        end
        
        %P1=[P1 P0];
        
    end
%     P2=[P2 P1];
%     mP=mean(P2,2);
%     mP1=reshape(mP,length(lat),length(long));
    
%------Carte-moyenne-mensuelle--------------------------------%
% figure(m)
% mymap=pcolor(long,lat,mP1);      %creer une map 
% mymap.EdgeAlpha=0;              %taille du maillage
% colormap(jet)                   %legend
% colorbar;             
% caxis([0;100])    
% xlabel('Longitude')
% ylabel('Latitude')
% tit=sprintf('Puissance moyenne mensuelle pour le %.2d (kW/m)',m);
% title(tit);
%     s=sprintf('PMA_%d.png',y);
%     saveas(gcf,s);
%--------------------------------------------------------%

    %end 
end
    
    