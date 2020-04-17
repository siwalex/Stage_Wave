clear,clc

H2=[];
mH2=[];
mTp2=[];
%for j=1:12
        filename=sprintf('2017_01.nc',j);
        %----------Convertion date------------------------%
        t=ncread(filename,'time');
        %date=datetime(1950, 1, 1, t, 0, 0);
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
            H=H0(12,16,i);
            H=H';
            H=H(:);
            H1=[H1 H];

            Tp=Tp0(12,16,i);
            Tp=Tp';
            Tp=Tp(:);
            Tp1=[Tp1 Tp];
        end
        
        H2=[H2 H1];
        mH1=mean(H1,2);         %Moyenne hauteur 1 mois
        mH2=[mH2 mH1];          %matrice moyenne hauteur 1 mois sur y années

        mTp1=mean(Tp1,2);
        %mTp2=[mTp2 mTp1];
%end

%---------------------------------------%
x=H2;
x(isnan(x))=0;
Fs=8;
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); %moitier
figure(202)
plot(Hpsd)

Hpsd = dspdata.psd(Pxx,'Fs',Fs,'SpectrumType','twosided'); %entier
figure(203)
plot(Hpsd)
%---------------------------------------%


%mH2=mean(mH2,2);    
% H2(isnan(H2))=0;
% x=H2;
% Ak=abs(fft(x))/length(x); % calcul du spectre d?amplitude
% fs=length(x);
% k=0:1:length(x)-1; % Génération de l?indice des fréqu.
% f=k*fs/length(x); % conversion en Hz
% figure(200)
% subplot(2,1,1);
% stem(x(2:length(x)))
% subplot(2,1,2); 
% plot(f(2:length(x)),Ak(2:length(x))); % trace du spectre d?amplitude

%---------------------------------------%
% x=H2;
% x(isnan(x))=0;
% Fs=length(x);
% N = length(x);
% xdft = fft(x);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(x):Fs/2;
% 
% figure(200)
% plot(freq,10*log10(psdx))
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% figure(201)
% periodogram(x,rectwin(length(x)),length(x),Fs)


