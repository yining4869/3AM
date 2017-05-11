function velo = Velocity( x,si,acce )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
for i=1:si(1)
velo(i,1)=trapz(x(1:i),acce(1:i,1),1);
velo(i,2)=trapz(x(1:i),acce(1:i,2),1);
velo(i,3)=trapz(x(1:i),acce(1:i,3),1);
end

end

