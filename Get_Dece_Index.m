function de_index = Get_Dece_Index( raw_data, sam_rate  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Set duration
duration=4;

% Set threshold
threshold_cos=0.9;
threshold_acce=0.03;

% Get vector length
si=size(raw_data,1);

% Get acceleration data
acce=9.8.*raw_data(:,2:4);
    
% Cancle noise
acce(:,3)=acce(:,3)-acce(1,3);

acce=acce';
Min=min(acce(3,:));
t=1:duration*sam_rate;
test_dece=t.*(t-duration*sam_rate-1);
Min_t=min(test_dece);
test_dece=(Min./Min_t).*test_dece;

de_index=1;

for i=1:1:si(1)-sam_rate*duration
    if(acce(3,i)<-threshold_acce)
        cos_angle=dot(test_dece,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test_dece));
        if(cos_angle>threshold_cos)
            de_index=i;
            break
        end
    end
end

% threshold=0.93;  % Thresold for determining start point
% acce_st=Acce_index(acce,sam_rate,threshold);
% dece_st=Dece_index(acce,sam_rate,threshold);
% st_index=min([acce_st dece_st]);




end

