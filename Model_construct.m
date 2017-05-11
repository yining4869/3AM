clear,clc,close all;

% File name and sheet name
file_name='AccelerometerSensorData13_5_cleaned.xlsx';

% Read in data
aban_front=30; % Abandon inital data
aban_back=20; % Abandon final data
raw_data=xlsread(file_name,1);
acce=raw_data(aban_front+1:end-aban_back,2:4);
si=size(acce); % Size of data matrix
sam_rate=100; % Sample rate

plot(acce(:,2));

[b,a]=butter(6,[0.45 0.55],'bandpass');
acce_f=filter(b,a,acce(:,2));

figure(2);
plot(acce_f);

ksdensity(acce(:,1));
figure(2);
ksdensity(acce(:,2));
figure(3);
ksdensity(acce(:,3));

% subplot(3,1,1);
% plot(xix,fx);
% hold on;
% plot(xix,normpdf(xix,mx,sx));
% subplot(3,1,2);
% plot(xiy,fy);
% hold on;
% plot(xiy,normpdf(xiy,my,sy));
% subplot(3,1,3);
% plot(xiz,fz);
% hold on;
% plot(xiz,normpdf(xiz,mz,sz));

% subplot(3,1,1);
% plot(acce(:,1));
% subplot(3,1,2);
% plot(acce(:,2));
% subplot(3,1,3);
% plot(acce(:,3));

% subplot(3,1,1);
% plot(xix,normpdf(xix,mx,sx));
% subplot(3,1,2);
% plot(xiy,normpdf(xiy,my,sy));
% subplot(3,1,3);
% plot(xiz,normpdf(xiz,mz,sz));

% Cancel background noise
bg_noise=BG_Noise();
acce(:,1)=acce(:,1)-mean(acce(:,1));
acce(:,2)=acce(:,2)-mean(acce(:,2));
acce(:,3)=acce(:,3)-mean(acce(:,3));

% figure(2);
% subplot(3,1,1);
% plot(acce(:,1));
% subplot(3,1,2);
% plot(acce(:,2));
% subplot(3,1,3);
% plot(acce(:,3));

% Time
x=(0:1/sam_rate:(si-1)/sam_rate)';

% Velocity
velo=Velocity(x,si,acce);

% subplot(3,1,1);
% plot(velo(:,1));
% subplot(3,1,2);
% plot(velo(:,2));
% subplot(3,1,3);
% plot(velo(:,3));


% Displacement
dis=Displacement(x,si,velo);

% Distance
dista=Distance(x,si,velo);

subplot(3,1,1);
plot(x,dista(:,1));
title('Sx');
ylabel('Sx m');
xlabel('t /s');
legend('Sample Rate=50Hz','Location','southeast');
subplot(3,1,2);
plot(x,dista(:,2));
title('Sy');
ylabel('Sy m');
xlabel('t /s');
subplot(3,1,3);
plot(x,dista(:,3));
title('Sz');
ylabel('Sz m');
xlabel('t /s');

figure(2);
subplot(3,1,1);
plot(x,dis(:,1));
title('Dx');
ylabel('Dx m');
xlabel('t /s');
legend('Sample Rate=50Hz','Location','southeast');
subplot(3,1,2);
plot(x,dis(:,2));
title('Dy');
ylabel('Dy m');
xlabel('t /s');
subplot(3,1,3);
plot(x,dis(:,3));
title('Dz');
ylabel('Dz m');
xlabel('t /s');

