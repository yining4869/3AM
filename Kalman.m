function [ output_args ] = Kalman( acce,velo,dis,x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
si=size(acce); % Size of data matrix
clear
N=100;
w(1)=0;
w=randn(1,N)
x(1)=0;
A=1;
for k=2:N;
    x(k)=A*x(k-1)+w(k-1);  %公式1  X(k|k-1)=A X(k-1|k-1)+B U(k)
end


V=randn(1,N);
q1=std(V);        %计算标准偏差
Rvv=q1.^2;      %点代表q是一个向量
q2=std(x);
Rxx=q2.^2;
q3=std(w);
Rww=q3.^2;
H=0.2;
Z=H*x+V;    %Z(k) = H(k)X(k)+V(k)

p(1)=0;
s(1)=0;
for t=2:si(1);
    p1(t)=A.^2*p(t-1)+Rww;                  %公式2  P(k|k-1)=A P(k-1|k-1) A’+Q 
    Kg(t)=H*p1(t)/(H.^2*p1(t)+Rvv);         %公式4  Kg(k)= P(k|k-1) H’ / (H P(k|k-1) H’ + R)
    s(t)=A*s(t-1)+Kg(t)*(acce(t,:)-A*H*s(t-1));  %公式3  X(k|k)= X(k|k-1)+Kg(k) (Z(k)-H X(k|k-1))
    p(t)=p1(t)-H*Kg(t)*p1(t);               %公式5  P(k|k)=（I-Kg(k) H）P(k|k-1) 
end

t=1:N;
plot(t,s,'r',t,Z,'g',t,x,'b'); % 

