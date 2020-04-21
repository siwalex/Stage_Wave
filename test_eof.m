clear,clc

H=[];
dim=3;
t=[];
for y=2017:2019     
    C=[];
    t2=[];
    for m=1:12         
        filename=sprintf('%d_%.2d.nc',y,m);
        %----------Convertion date------------------------%
        t1=ncread(filename,'time');
        date=datetime(1950, 1, 1, t, 0, 0);
        %-------------------------------------------------%

        %-----Extraire longitude latitute ---------------%
        long=ncread(filename,'longitude');    %r�ccup�ration de la matrice des longitudes
        lat=ncread(filename,'latitude'); 
        %--------------------------------------------------------%

        %-----Extraire les donn�es du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        Tp0=ncread(filename,'VTPK');      %Peak period
        
        C = cat(dim,C,H0);
        t2=[t2 ;t1];
        
    end
    H=cat(dim,H,C); %matice de toutes les donn�es, tout les temps, toutes les coordonn�es
    t=[t ;t2];
end

%-------donn�es centr�es r�duites-------%
for i=1:73
    for j=1:37
    CS(i,j,:)=zscore(H(i,j,:)); %moyenne/ecart-type
    end
end
%---------------------------------------%

sst=CS;
n=6; %nombre de composantes principales � afficher
[eof_maps,pc,expv] = eof(sst,n);
%eof_maps = cartes des composantes principales
%pc = composantes principales en temps
%expv = pourcentage de variance

%--------------Anomalie-----------------%
figure(2)
anomaly(t,pc(1,:))
%---------------------------------------%

% Plot the first mode: %
figure(4)
imagescn(long,lat,eof_maps(:,:,1))
colorbar
axis xy image
cmocean('curl')
title 'The first EOF mode!'
%---------------------------------------%

%--Trace les cartes des composantes principales--%
s = [-1 1 -1 1 -1 1];

figure('pos',[100 100 500 700])
for k = 1:6
   subplot(3,2,k)
   imagescn(long,lat,eof_maps(:,:,k)*s(k));
   axis xy off
   title(['Mode ',num2str(k),' (',num2str(expv(k),'%0.1f'),'%)'])
   colorbar
   caxis([-0.06;0.06]) 
   cmocean curl
end
%---------------------------------------%

%--------------Variance-----------------%
% figure(3)
% imagesc(long,lat,var(sst,[],3));
% axis xy off
% colorbar
% title('variance of temperature')
% colormap(jet) 
% caxis([0 1])
%---------------------------------------%

%--------------Moyenne------------------%
% figure (1)
% imagescn(long,lat,mean(H,3));
% axis xy off
% cb = colorbar;
% ylabel(cb,' hauteur moyenne (m) ')
% cmocean ('rain')
%---------------------------------------%
