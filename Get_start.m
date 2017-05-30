function st_index = Get_start( acce, sam_rate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Set duration
duration=4;

% Set threshold
threshold_cos=0.93;
threshold_h=0.07;

% Get vector length
si=size(raw_data,1);

% Get height data
hei=raw_data(:,end);
hei=hei-hei(1,1);

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
Min=min(acce(3,:));
t=1:duration*sam_rate;
test_dece=t.*(t-duration*sam_rate-1);
Min_t=min(test_dece);
test_dece=(Min./Min_t).*test_dece;

st_index=1;

for i=1:1:si(1)-sam_rate*duration
    if(hei(i)>threshold_h)
        cos_angle=dot(test_acce,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test_acce));
        if(cos_angle>threshold_cos)
            st_index=i;
            break
        end
    elseif(hei(i)<-threshold_h)
        cos_angle=dot(test_dece,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test_dece));
        if(cos_angle>threshold_cos)
            st_index=i;
            break
        end
    end
end
end

