clear,clc,close all;

file_name=uigetfile('*.xlsx','Open data file');
raw_data=xlsread(file_name,1);
acce=9.8.*raw_data(:,2:4);
si=size(acce);

sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));

acce(:,1)=acce(:,1)-mean(acce(:,1));
acce(:,2)=acce(:,2)-mean(acce(:,2));
acce(:,3)=acce(:,3)-mean(acce(:,3));

x=(0:1/sam_rate:(si-1)/sam_rate)';

subplot(2,1,1);
plot(x,acce(:,3));
title('Az');
ylabel('Az m/s^2');
xlabel('t /s');
hold on;zoom on;

acce_ft=fft(acce(:,3));
acce_ft=acce_ft(1:floor(si/2)+1);
acce_ft(2:end-1)=2*acce_ft(2:end-1);

subplot(2,1,2);
plot(abs(acce_ft));
title('Amplitude');
% ylabel('Az m/s^2');
xlabel('t /s');
hold on;zoom on;