% clc,clear
% 
% Fs = 1000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 1500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
% 
% X = S + 2*randn(size(t));
% 
% plot(1000*t(1:150),X(1:150))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('t (milliseconds)')
% ylabel('X(t)')


% inc=0;
% f=0;
% for u=-100:0.1:100
%     inc=inc+1;
%     if (u>-1 && u<1)
%        f(inc)=1;
%     else
%         f(inc)=0;
%     end
% end
%  
% u=-100:0.1:100;
% subplot(2,1,1)
% plot(u,f)

%-----Extraire les données du fichier .nc ---------------%
filename='2016_03.nc';

long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
lat=ncread(filename,'latitude');
H0=ncread(filename,'VHM0');
Tp=ncread(filename,'VTPK');      %Peak period
t=ncread(filename,'time');
vmdr=ncread(filename,'VMDR_WW');
vped=ncread(filename,'VPED');

F=fft(vmdr);
 
Pff=F.*conj(F) / numel(F);
freq=10*(0:1:((numel(F)-1)/2))/(numel(F)-1);
% subplot(2,1,2)
plot(freq,Pff(1:((numel(F)-1)/2+1)))

