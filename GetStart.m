function st_index = GetStart( acce )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dif=diff(acce);
si=size(dif);
st_index=1;
for i=1:si(1)-10
    if(((mean(acce(i:i+5,3))<mean(acce(i:i+10,3)))&&(mean(dif(i:i+5,3))>0.02))||((mean(acce(i:i+5,3))>mean(acce(i:i+10,3)))&&(mean(dif(i:i+5,3))<-0.02)))
        st_index=i;
        break;
    end
end
end

