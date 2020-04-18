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
        long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
        lat=ncread(filename,'latitude'); 
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        Tp0=ncread(filename,'VTPK');      %Peak period
        
        C = cat(dim,C,H0);
        t2=[t2 ;t1];
    end
    H=cat(dim,H,C);
    t=[t ;t2];
end

sst=H;
n=6;
[eof_maps,pc,expv] = eof(sst,n);

%--------------Moyenne------------------%
figure (1)
imagesc(long,lat,mean(sst,3));
axis xy off
cb = colorbar;
ylabel(cb,' hauteur moyenne (m) ')
cmocean ('rain')
%---------------------------------------%

%--------------Anomalie-----------------%
figure(2)
anomaly(t,pc(1,:))
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

% Plot the first mode:
figure(4)
imagesc(long,lat,eof_maps(:,:,1))
colorbar
axis xy image
cmocean('curl')
title 'The first EOF mode!'
%---------------------------------------%

s = [-1 1 -1 1 -1 1]; % (sign multiplier to match Messie and Chavez 2011)

figure('pos',[100 100 500 700])
for k = 1:6
   subplot(3,2,k)
   imagesc(long,lat,eof_maps(:,:,k)*s(k));
   axis xy off
   title(['Mode ',num2str(k),' (',num2str(expv(k),'%0.1f'),'%)'])
   colorbar
   cmocean curl
end
%colormap jet


