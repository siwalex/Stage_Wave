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
        long=long(38:50);
        lat=ncread(filename,'latitude'); 
        lat=lat(16:28);
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        H0=ncread(filename,'VHM0');     %Hauteur
        H0=H0(38:50,16:28,:);
        Tp0=ncread(filename,'VTPK');      %Peak period
        Tp0=Tp0(38:50,16:28,:);
        %--------------------------------------------------------%
        
        C = cat(dim,C,H0);
        t2=[t2 ;t1];
    end
    H=cat(dim,H,C); %matice de toutes les données, tout les temps, toutes les coordonnées
    t=[t ;t2];
end
%%
U=H(:,:,1);
%--------------psd-H nord run----------%
Hnr=H(6,11,:);  %extraire une coordonnée au nord
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
tit=sprintf('Puissance de densité spectrale au Nord de Maurice');
title(tit);
s=sprintf('PSD_Nord_MAU.png');
saveas(gcf,s);
%%---------------------------------------%


%%
%--------------psd-H sud run------------%
Hnr=H(6,2,:);
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
tit=sprintf('Puissance de densité spectrale au Sud de Maurice');
title(tit);
s=sprintf('PSD_Sud_MAU.png');
saveas(gcf,s);
%---------------------------------------%
%%
%--------------psd-H Ouest run------------%
Hnr=H(2,6,:);
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
tit=sprintf('Puissance de densité spectrale au Ouest de Maurice');
title(tit);
s=sprintf('PSD_Ouest_MAU.png');
saveas(gcf,s);
%---------------------------------------%
%%
%--------------psd-H Est run------------%
Hnr=H(11,6,:);
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
tit=sprintf('Puissance de densité spectrale au Est de Maurice');
title(tit);
s=sprintf('PSD_Est_MAU.png');
saveas(gcf,s);
%---------------------------------------%
