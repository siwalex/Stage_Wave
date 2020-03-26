clc,clear

t = 0:0.001:1-0.001;
x = cos(2*pi*100*t);
[xc,lags] = xcorr(x,'coeff');
stem(lags,xc)

stem(lags(length(x):length(x)+50),xc(length(x):length(x)+50));
xlabel('Lags'); ylabel('ACF');