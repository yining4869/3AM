clear,clc,close all;

% File name and sheet name
file_name='AccelerometerSensorData1_cleaned.xlsx';
sheet_name='AccelerometerSensorData1';

% Read in data
raw_data=xlsread(file_name,sheet_name);
acce=raw_data(800:end-200,2:4);
si=size(acce); % Size of data matrix

acce(acce>0.3)=mean(acce(:,3),1);

mean(acce,1)

% subplot(3,1,1);
% plot(acce(:,1));
% subplot(3,1,2);
% plot(acce(:,2));
% subplot(3,1,3);
% plot(acce(:,3));