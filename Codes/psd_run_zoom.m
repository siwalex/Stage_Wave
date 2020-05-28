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
        %--------------------------------------------------------%
        
        C = cat(dim,C,H0);
        t2=[t2 ;t1];
    end
    H=cat(dim,H,C); %matice de toutes les données, tout les temps, toutes les coordonnées
    t=[t ;t2];
end

%--------------psd-H nord run----------%
Hnr=H(7,12,:);  %extraire une coordonnée au nord
y=Hnr(:);
data=y;

Fs=1;
freq = 0:Fs/length(data):Fs/2;
x=3*(1./freq)./24;

N = length(data);
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdxn=psdx;

%---------------------------------------%

%--------------psd-H sud run------------%
Hnr=H(7,2,:);
y=Hnr(:);
data=y;
N = length(data);
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdxs=psdx;
% %---------------------------------------%

% %--------------psd-H Ouest run------------%
Hnr=H(2,7,:);
y=Hnr(:);
data=y;
N = length(data);
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdxo=psdx;
%---------------------------------------%

%--------------psd-H Est run------------%
Hnr=H(12,7,:);
y=Hnr(:);
data=y;
N = length(data);
xdft = fft(data);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdxe=psdx;
%---------------------------------------%

figure(1)
plot(x,psdxn,'-o',x,psdxs,'-s',x,psdxo,'-x',x,psdxe,'-p') 
legend('nord','sud','ouest','est')
xlabel('Période (jour)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale de La Réunion');
title(tit);
set(gca,'FontSize', 16)
s=sprintf('PSD_RUN.png');
saveas(gcf,s);

figure(2)
plot(x,psdxn,'-o',x,psdxs,'-s',x,psdxo,'-x',x,psdxe,'-p') 
xlim([0 150])
legend('nord','sud','ouest','est')
xlabel('Période (jour)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale de La Réunion');
title(tit);
set(gca,'FontSize', 16)
s=sprintf('PSD_RUN_150j.png');
saveas(gcf,s);

figure(3)
plot(x,psdxn,'-o',x,psdxs,'-s',x,psdxo,'-x',x,psdxe,'-p') 
xlim([0 15])
legend('nord','sud','ouest','est')
set(legend,'location','best')
xlabel('Période (jour)')
ylabel('Amplitude de la fréquence')
tit=sprintf('Puissance de densité spectrale de La Réunion');
title(tit);
set(gca,'FontSize', 16)
s=sprintf('PSD_RUN_15j.png');
saveas(gcf,s);


