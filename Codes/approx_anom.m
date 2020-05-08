clear,clc

H2=[];
dim=3;
t=[];
d=[];
for y=2017:2019     
    C=[];
    t2=[];
    d1=[];
    for m=1:12         
        filename=sprintf('%d_%.2d.nc',y,m);
        %----------Convertion date------------------------%
        t1=ncread(filename,'time');
        %date=datetime(1950, 1, 1, t1, 0, 0);
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
        d1=[d1 ;date];
        
    end
    H2=cat(dim,H2,C); %matice de toutes les données, tout les temps, toutes les coordonnées
    t=[t ;t2];
    d=[d ;d1];
end
H=permute(H2,[2 1 3]);

%-------données centrées réduites-------%
for j=1:73
    for i=1:37
    CS(i,j,:)=zscore(H(i,j,:)); %moyenne/ecart-type
    end
end
%---------------------------------------%

sst=CS;
n=6; %nombre de composantes principales à afficher
[eof_maps,pc,expv] = eof(sst,n);
%eof_maps = cartes des composantes principales
%pc = composantes principales en temps
%expv = pourcentage de variance

%%
%--------------Anomalie-----------------%
figure
startDate = datenum('01-01-2017');
endDate = datenum('12-31-2019');
xData = linspace(startDate,endDate,length(t));

anomaly(xData,pc(1,:))

hold on
xdata=xData';
f=fit(xdata,pc(1,:)','smoothingspline','SmoothingParam',0.000001);
plot(f,'-or')

grid on
ax = gca;
ax.XTick = xData;
datetick('x','yyyy mmm dd','keeplimits')
xlabel('Dates')
ylab=sprintf('Coefficient des composantes \n principales temporelles');
ylabel(ylab);
xlim([startDate endDate]);
set(ax, 'FontSize', 15)
tit=sprintf('Anomaly');
title(tit);


% s=sprintf('Anomaly.png');
% saveas(gcf,s);




