clear,clc
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
        long=ncread(filename,'longitude');    %réccupération de la matrice des longitudes
        long=long(38:50);
        lat=ncread(filename,'latitude'); 
        lat=lat(16:28);
        %--------------------------------------------------------%

        %-----Extraire les données du fichier .nc ---------------%
        dir=ncread(filename,'VMDR');    %réccupération de la matrice des longitudes
        D0=dir(38:50,16:28,:);
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
%------------------direction annuelle-------------------%
figure(1)
M=20;
ocean_rose(D3(:),25);
histogram(D3(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution annuelle de la direction \n des vagues dans la zone C');
title(tit);
xlabel('Direction (°)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_A_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------------------direction hiver-------------------%
D5_10=D3(:,2881:7288);
figure(2)
%h=ocean_rose(D5_10(:),25);
histogram(D5_10(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution de la période \n dans la zone C, de mai à octobre');
title(tit);
xlabel('Direction (°)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_hivers_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%

%------------------direction ete-------------------%
D11_12=D3(:,8008:8752);
D1_4=D3(:,1:2880);
D12_4=[];
D12_4=[D11_12 D1_4];
figure(3)
%h=ocean_rose(D12_4(:),25);
histogram(D12_4(:),25,'Normalization','probability')
xticks([0  45 90 135 180 225 270 315])
xticklabels({'Nord', '45', 'Est', '135', 'Sud', '225', 'Ouest', '315'})
tit=sprintf('Distribution de la hauteur des vagues \n dans la zone C, de novembre à avril');
title(tit);
xlabel('Direction (°)')
ylabel('Frequence')
set(gca,'FontSize', 20)
s=sprintf('Dir_ete_mau.png');
saveas(gcf,s);
%--------------------------------------------------------%






