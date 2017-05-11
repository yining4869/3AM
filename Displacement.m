function dis = Displacement( x,si,velo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dis=zeros(si);

for i=1:si(1)
dis(i,1)=trapz(x(1:i),velo(1:i,1),1);
dis(i,2)=trapz(x(1:i),velo(1:i,2),1);
dis(i,3)=trapz(x(1:i),velo(1:i,3),1);
end

end

