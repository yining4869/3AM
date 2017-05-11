function [ acce_index ] = Acce_index( acce, sam_rate ,threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
duration=4;
si=size(acce);
Max=max(acce(:,3));
t=1:duration*sam_rate;
test=-t.*(t-duration*sam_rate-1);
Max_t=max(test);
test=(Max./Max_t).*test;
acce=acce';
acce_index=1;
for i=1:1:si(1)-sam_rate*duration
    cos_angle=dot(test,acce(3,i:i+sam_rate*duration-1))/(norm(acce(3,i:i+sam_rate*duration-1))*norm(test))
    if(cos_angle>threshold)
        acce_index=i
        break
    end
end
% figure(2);
% plot(t,acce(3,acce_index:acce_index+sam_rate*duration-1));

end

