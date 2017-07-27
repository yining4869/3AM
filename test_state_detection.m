clear,clc,close all

% Duration of acceleration and deceleration
duration=4;

STILL=1;
ACCE=2;
DECE=3;
MOV_UP=4;
MOV_DOWN=5;
ACCE_TOSTILL=6;
DECE_TOSTILL=7;

[acce_st, dece_st, steady_st, still_back, acce_tostill, dece_tostill]=deal(0);

threshold=0.1;

sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
[file_name,~,index]=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');

raw_data=xlsread(file_name,1);
acce=9.8.*raw_data(:,2:4);

acce_index=Get_Acce_Index(raw_data, sam_rate);
dece_index=Get_Dece_Index(raw_data, sam_rate);

si=size(acce,1);

acce(:,3)=acce(:,3)-acce(1,3);
    
% Time
x=(0:1/sam_rate:(si-1)/sam_rate)';


time_acce=1;
time_dece=1;

state=STILL;

for i=1:si
    switch state
    case STILL
        if i==acce_index
            state=ACCE;
            acce_st=i/sam_rate;
        elseif i==dece_index
            state=DECE;
            dece_st=i/sam_rate;
        end
    case ACCE
        if (i>=acce_index+sam_rate*duration)&&(acce(i,3)<=threshold)
            state=MOV_UP;
            steady_st=i/sam_rate;
        end
    case ACCE_TOSTILL
        if (i>=acce_index+sam_rate*duration)&&(acce(i,3)<=threshold)
            state=STILL;
            still_back=i/sam_rate;
        end
    case MOV_UP
        if i==dece_index
            state=DECE_TOSTILL;
            dece_tostill=i/sam_rate;
        end
    case MOV_DOWN
        if i==acce_index
            state=ACCE_TOSTILL;
            acce_tostill=i/sam_rate;
        end
    case DECE
        if (i>=dece_index+sam_rate*duration)&&(acce(i,3)>=-threshold)
            state=MOV_DOWN;
            steady_st=i/sam_rate;
        end
    case DECE_TOSTILL
        if (i>=dece_index+sam_rate*duration)&&(acce(i,3)>=-threshold)
            state=STILL;
            still_back=i/sam_rate;
        end
    end
end

plot(x,acce(:,3));
title('Acceleration Az');
ylabel('Az m/s^2');
xlabel('t /s');

if acce_st~=0
    text(acce_st,-0.01,'\uparrow start moving up');
end
if dece_st~=0
    text(dece_st,0.01,'\downarrow start moving down');
end
if steady_st~=0
    text(steady_st,-0.01,'\uparrow begin steady movement');
end
if still_back~=0
    text(still_back,-0.01,'\uparrow back to stillness');
end
if dece_tostill~=0
    text(dece_tostill,0.01,'\downarrow decelerate to stillness');
end
if acce_tostill~=0
    text(acce_tostill,-0.01,'\uparrow accelerate to stillness');
end
