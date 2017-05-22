function Q_loc_est = Kalman_filter( raw_data, sam_rate )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u=9.8.*raw_data(:,4);
u=u-u(1,1);
y=raw_data(:,end);
y=y-y(1,1);

% Define system
duration=size(u,1);
dt=1/sam_rate;
a=[1 dt;0 1];
b=[dt^2/2;dt];
c=[1 0];
d=0;
% sys=ss(a, b, c, d, dt, 'inputname', 'a', 'outputname', 'h');

% Define main variables
% u=1.5;
Q=[0;0];
Q_est=Q;
sta_noi_mag=1;    % State estimation noise
mea_noi_mag=1;    % Measurement estimation noise
e_x=sta_noi_mag^2*[dt^4/4 dt^3/2;dt^3/2 dt^2];
e_z=mea_noi_mag^2;
P=e_x;

% Initiate result variables
Q_loc=[];   % Actual height data
vel=[]; % Actual velocity data
Q_loc_mea=[];   % Measured height data

% Simulate
for t=0:dt:(duration-1)/sam_rate
%     sta_noi=sta_noi_mag*randn*[(dt^2/2);dt];
%     Q=a*Q+b*u(t/dt+1)+sta_noi;
    i=floor(t/dt+1);
    Q=a*Q+b*u(i);
%     mea_noi=mea_noi_mag*randn;
%     y=c*Q+mea_noi;
    Q_loc=[Q_loc;Q(1)];
    Q_loc_mea=[Q_loc_mea;y(i)];
    vel=[vel;Q(2)];
end

% Do kalman filter
Q_loc_est=[];
vel_est=[];
Q=[0;0];
P_est=P;
P_mag_est=[];
state_pre=[];
var_pre=[];
for t=1:length(Q_loc);
    Q_est=a*Q_est+b*u(i);
    state_pre=[state_pre;Q_est(1)];
    P=a*P*a'+e_x;
    var_pre=[var_pre;P];
    K=P*c'*inv(c*P*c'+e_z);
    Q_est=Q_est+K*(Q_loc_mea(t)-c*Q_est);
    P=(eye(2)-K*c)*P;
    Q_loc_est=[Q_loc_est;Q_est(1)];
    vel_est=[vel_est;Q_est(2)];
    P_mag_est=[P_mag_est;P(1)];
end


end

