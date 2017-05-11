function st_index = Get_start( acce, sam_rate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
threshold=0.94;  % Thresold for determining start point
si=size(acce,1);
acce_st=Acce_index(acce,sam_rate,threshold);
dece_st=Dece_index(acce,sam_rate,threshold);
% if(acce_st==dece_st)
%     acce_st=Acce_index(acce,sam_rate);
%     dece_st=Dece_index(acce,sam_rate);
% end
st_index=min([acce_st dece_st]);

end

