function [ acce,velo,dis,x,h ] = Calculation( file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Gravity constant
g=9.8;

% Read in data
raw_data=xlsread(file_name,1);

sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
aban_front=sam_rate.*str2num(cell2mat(inputdlg('Input abandon time at front:'))); % Abandon initial data
aban_back=sam_rate.*str2num(cell2mat(inputdlg('Input abandon time at back:'))); % Abandon final data
acce=g.*raw_data(aban_front+1:end-aban_back,2:4);
si=size(acce); % Size of data matrix

% Read height data
h=raw_data(aban_front+1:end-aban_back,end);
h=h-h(1,1);

% Cancel noise
% acce(:,1)=acce(:,1)-mean(acce(:,1));
% acce(:,2)=acce(:,2)-mean(acce(:,2));
acce(:,3)=acce(:,3)-mean(acce(:,3));
% acce=CancelNoise(acce);

% Time
x=(0:1/sam_rate:(si-1)/sam_rate)';

% Velocity
velo=Velocity(x,si,acce);

% Displacement
dis=Displacement(x,si,velo);

end

