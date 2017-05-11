function [ dece_index ] = Dece_index_backup( acce, sam_rate )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
duration=4;
si=size(acce);
Min=min(acce(:,3));
t=1:duration*sam_rate;
test=t.*(t-duration*sam_rate-1);
Min_t=min(test);
test=(Min./Min_t).*test;
acce=acce';
dece_index=1;
corr=-1;
for i=1:1:si(1)-sam_rate*duration
    cos_angle=dot(test,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test));
    if(cos_angle>corr)
        corr=cos_angle;
        dece_index=i;
    end
end
% figure(2);
% plot(t,acce(3,acce_index:acce_index+sam_rate*duration-1));


end