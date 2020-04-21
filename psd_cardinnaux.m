clear,clc


H1=[];
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
    H1=cat(dim,H1,C); %matice de toutes les donn�es, tout les temps, toutes les coordonn�es
    t=[t ;t2];
end

%-------donn�es centr�es r�duites-------%
for i=1:73
    for j=1:37
    CS(i,j,:)=zscore(H1(i,j,:)); %moyenne/ecart-type
    end
end
H=CS;
%---------------------------------------%

%--------------psd-H nord run----------%
Hnr=H(12,16,:);  %extraire une coordonn�e au nord
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
xlabel('P�riode')
ylabel('Amplitude (au carr�)')
tit=sprintf('Puissance de densit� spectrale au Nord de La R�union');
title(tit);
%%---------------------------------------%

%--------------psd-H sud run------------%
Hnr=H(12,24,:);
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
xlabel('P�riode')
ylabel('Amplitude (au carr�)')
tit=sprintf('Puissance de densit� spectrale au Sud de La R�union');
title(tit);
%---------------------------------------%

%--------------psd-H Ouest run------------%
Hnr=H(8,21,:);
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
xlabel('P�riode')
ylabel('Amplitude (au carr�)')
tit=sprintf('Puissance de densit� spectrale au Ouest de La R�union');
title(tit);
%---------------------------------------%

%--------------psd-H Est run------------%
Hnr=H(16,21,:);
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
xlabel('P�riode')
ylabel('Amplitude (au carr�)')
tit=sprintf('Puissance de densit� spectrale au Est de La R�union');
title(tit);
%---------------------------------------%
