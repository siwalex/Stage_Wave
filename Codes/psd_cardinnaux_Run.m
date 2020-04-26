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
        long=long(14:27);
        lat=ncread(filename,'latitude'); 
        lat=lat(6:19);
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        H0=H0(14:27,6:19,:);
        Tp0=ncread(filename,'VTPK');      %Peak period
        Tp0=Tp0(14:27,6:19,:);
        %--------------------------------------------------------%
        
        C = cat(dim,C,H0);
        t2=[t2 ;t1];
    end
    H=cat(dim,H,C); %matice de toutes les données, tout les temps, toutes les coordonnées
    t=[t ;t2];
end

% %figure
% %pcolor(long,lat,H2(:,:,1));
% V=H2(:,:,1);
% 
% H=permute(H2,[2 1 3]);
% 
% %figure
% %pcolor(long,lat,H(:,:,1));
% U=H(:,:,1);

%--------------psd-H nord run----------%
Hnr=H(7,12,:);  %extraire une coordonnée au nord
figure
y=Hnr(:);
%Fs=1/length(y);  %frequence
data=y;
N = length(data);
Fs=1;
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(data):Fs/2;
plot(1./freq,psdx,'-ok')     
xlabel('Période (en heure)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale au Nord de La Réunion');
title(tit);
s=sprintf('PSD_Nord_RUN.png');
saveas(gcf,s);
%---------------------------------------%



%--------------psd-H sud run------------%
Hnr=H(7,2,:);
figure
y=Hnr(:);
Fs=1/length(y);
data=y;
N = length(data);
Fs=1;
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(data):Fs/2;
plot(1./freq,psdx,'-ok')  
xlabel('Période (en heure)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale au Sud de La Réunion');
title(tit);
s=sprintf('PSD_Sud_RUN.png');
saveas(gcf,s);
%---------------------------------------%

%--------------psd-H Ouest run------------%
Hnr=H(2,7,:);
figure
y=Hnr(:);
Fs=1/length(y);
data=y;
N = length(data);
Fs=1;
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(data):Fs/2;
plot(1./freq,psdx,'-ok')  
xlabel('Période (en heure)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale au Ouest de La Réunion');
title(tit);
s=sprintf('PSD_Ouest_RUN.png');
saveas(gcf,s);
%---------------------------------------%

%--------------psd-H Est run------------%
Hnr=H(12,7,:);
figure
y=Hnr(:);
Fs=1/length(y);
data=y;
N = length(data);
Fs=1;
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(data):Fs/2;
plot(1./freq,psdx,'-ok')  
xlabel('Période (en heure)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale au Est de La Réunion');
title(tit);
s=sprintf('PSD_Est_RUN.png');
saveas(gcf,s);
%---------------------------------------%
