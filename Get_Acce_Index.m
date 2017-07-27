function st_index = Get_Acce_Index( raw_data, sam_rate )
%UNTITLED2 Summary of this function goes here
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
Max=max(acce(3,:));
t=1:duration*sam_rate;
test_acce=-t.*(t-duration*sam_rate-1);
Max_t=max(test_acce);
test_acce=(Max./Max_t).*test_acce;

st_index=1;

for i=1:1:si(1)-sam_rate*duration
    if(acce(3,i)>threshold_acce)
        cos_angle=dot(test_acce,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test_acce));
        if(cos_angle>threshold_cos)
            st_index=i;
            break
        end
    end
end

% threshold=0.93;  % Thresold for determining start point
% acce_st=Acce_index(acce,sam_rate,threshold);
% dece_st=Dece_index(acce,sam_rate,threshold);
% st_index=min([acce_st dece_st]);


end

