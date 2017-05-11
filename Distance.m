function dista = Distance( x,si,velo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dista=zeros(si);

for i=1:si(1)
dista(i,1)=trapz(x(1:i),abs(velo(1:i,1)),1);
dista(i,2)=trapz(x(1:i),abs(velo(1:i,2)),1);
dista(i,3)=trapz(x(1:i),abs(velo(1:i,3)),1);
end

end

