clear,clc

%ncdisp '2016_03.nc'
mD4=[];
D3=[];
for m=1:12     %boucle Annees
    mD2=[];
    D2=[];
    for y=2017:2019
        filename=sprintf('%d_%.2d.nc',y,m);
        %----------Convertion date------------------------%
        t=ncread(filename,'time');
        date=datetime(1950, 1, 1, t, 0, 0);
        %-------------------------------------------------%

        %-----Extraire longitude latitute ---------------%
        long=ncread(filename,'longitude');    %r�ccup�ration de la matrice des longitudes
        long=long(14:27);
        lat=ncread(filename,'latitude'); 
        lat=lat(6:19);
        %--------------------------------------------------------%

        %-----Extraire les donn�es du fichier .nc ---------------%
        dir=ncread(filename,'VMDR');    %r�ccup�ration de la matrice des longitudes
        D0=dir(14:27,6:19,:);
        %--------------------------------------------------------%
        D1=[];
        for i=1:length(t)

            D=D0(:,:,i);
            D=D';
            D=D(:);
            D1=[D1 D];
        end
        D2=[D2 D1];
    end 
    D3=[D3 D2];
end
%%
figure(1)
M=20;
ocean_rose(D3(:),25);
histogram(D3(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution annuelle de la direction \n des vagues dans la zone B');
title(tit);
xlabel('Direction (�)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_A_run.png');
saveas(gcf,s);

%------------------direction hivers-------------------%
D5_10=D3(:,2881:7288);
figure(2)
%h=ocean_rose(D5_10(:),25);
histogram(D5_10(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution de la p�riode \n dans la zone B, de mai � octobre');
title(tit);
xlabel('Direction (�)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_hiver_run.png');
saveas(gcf,s);

%------------------direction �t�-------------------%
D11_12=D3(:,8008:8752);
D1_4=D3(:,1:2880);
D12_4=[];
D12_4=[D11_12 D1_4];
figure(3)
%h=ocean_rose(D12_4(:),25);
histogram(D12_4(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution de la hauteur des vagues \n dans la zone B, de novembre � avril');
title(tit);
xlabel('Direction (�)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_ete_run.png');
saveas(gcf,s);
%--------------------------------------------------------%








