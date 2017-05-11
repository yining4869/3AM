function bgnoise = BG_Noise()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Read in data
file_name='AccelerometerSensorData2_3_2_20_18_cleaned.xlsx';
sheet_name='AccelerometerSensorData2_3_2_20';
aban_front=30; % Abandon inital data
aban_back=20; % Abandon final data
raw_data=xlsread(file_name,sheet_name);
acce=raw_data(aban_front+1:end-aban_back,2:4);
si=size(acce); % Size of data matrix

[mx,~]=normfit(acce(:,1));
[my,~]=normfit(acce(:,2));
[mz,~]=normfit(acce(:,3));

bgnoise=[mx my mz];

end

