clear,clc,close all

% Duration of acceleration and deceleration
duration=4;

% States
STILL=1;
ACCE=2;
DECE=3;
MOV_UP=4;
MOV_DOWN=5;
ACCE_TOSTILL=6;
DECE_TOSTILL=7;

% Initialize critical points
[acce_st, dece_st, steady_st, still_back, acce_tostill, dece_tostill]=deal([]);

threshold=0.1;

sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
[file_name,~,index]=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');

raw_data=xlsread(file_name,1);
acce=9.8.*raw_data(:,2:4);

% Get acceleration and deceleration start points
acce_index=Get_Acce_Index(raw_data, sam_rate);
dece_index=Get_Dece_Index(raw_data, sam_rate);

si=size(acce,1);

acce(:,3)=acce(:,3)-acce(1,3);
    
% Time
x=(0:1/sam_rate:(si-1)/sam_rate)';

% Initialize states
state=STILL;

% Acceleration point and deceleration point to be compared next
n_acce=1;
n_dece=1;

plot(x,acce(:,3));
title('Acceleration Az');
ylabel('Az m/s^2');
xlabel('t /s');
grid on;zoom on;

% FSM
for i=1:si
    switch state
    case STILL
        if (n_acce<=size(acce_index,1))&&(n_dece<=size(dece_index,1))    
            if i==acce_index(n_acce)
                state=ACCE;
                acce_st=[acce_st;i];
                n_acce=n_acce+1;
            elseif i==dece_index(n_dece)
                state=DECE;
                dece_st=[dece_st;i];
                n_dece=n_dece+1;
            end
        end
    case ACCE
        if (i>=acce_index(n_acce-1)+sam_rate*duration)&&(acce(i,3)<=threshold)
            state=MOV_UP;
            steady_st=[steady_st;i];
        end
    case ACCE_TOSTILL
        if (i>=acce_index(n_acce-1)+sam_rate*duration)&&(acce(i,3)<=threshold)
            state=STILL;
            still_back=[still_back;i];
        end
    case MOV_UP
        if i==dece_index(n_dece)
            state=DECE_TOSTILL;
            dece_tostill=[dece_tostill;i];
            n_dece=n_dece+1;
        end
    case MOV_DOWN
        if i==acce_index(n_acce)
            state=ACCE_TOSTILL;
            acce_tostill=[acce_tostill;i];
            n_acce=n_acce+1;
        end
    case DECE
        if (i>=dece_index(n_dece-1)+sam_rate*duration)&&(acce(i,3)>=-threshold)
            state=MOV_DOWN;
            steady_st=[steady_st;i];
        end
    case DECE_TOSTILL
        if (i>=dece_index(n_dece-1)+sam_rate*duration)&&(acce(i,3)>=-threshold)
            state=STILL;
            still_back=[still_back;i];
        end
    end
end

if acce_st~=0
    text(acce_st./sam_rate,-0.01.*ones(size(acce_st,1),1),'\uparrow start moving up');
end
if dece_st~=0
    text(dece_st./sam_rate,0.01.*ones(size(dece_st,1),1),'\downarrow start moving down');
end
if steady_st~=0
    text(steady_st./sam_rate,-0.02.*ones(size(steady_st,1),1),'\uparrow begin steady movement');
end
if still_back~=0
    text(still_back./sam_rate,-0.02.*ones(size(still_back,1),1),'\uparrow back to stillness');
end
if dece_tostill~=0
    text(dece_tostill./sam_rate,0.03.*ones(size(dece_tostill,1),1),'\downarrow decelerate to stillness');
end
if acce_tostill~=0
    text(acce_tostill./sam_rate,-0.03.*ones(size(acce_tostill,1),1),'\uparrow accelerate to stillness');
end
