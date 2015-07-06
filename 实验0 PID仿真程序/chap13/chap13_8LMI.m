% H Infinity Controller Design based on LMI for Single Link Inverted Pendulum
clear all;
close all;

%Single Link Inverted Pendulum Parameters
g=9.8;M=1.0;m=0.1;L=0.5;
I=1/12*m*L^2;  
l=1/2*L;
t1=m*(M+m)*g*l/[(M+m)*I+M*m*l^2];
t2=-m^2*g*l^2/[(m+M)*I+M*m*l^2];
t3=-m*l/[(M+m)*I+M*m*l^2];
t4=(I+m*l^2)/[(m+M)*I+M*m*l^2];

A=[0,0,1,0;
   0,0,0,1;
   t1,0,0,0;
   t2,0,0,0];
B2=[0;0;t3;t4];
B1=[0;0;1;1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=1;q2=1;q3=1;q4=1;
q=[q1,q2,q3,q4];
gama=100;

C1=[diag(q);zeros(1,4)];
rho=1;
D12=[0;0;0;0;rho];
D11=zeros(5,1);
%%%%%%%%%%%%%%%%%%%%%%% LMI Model Design %%%%%%%%%%%%%%%%%%%%%%%
setlmis([]);  %Initializes the description of a new LMI system.

P1=lmivar(1,[4 1]);   % define P1
P2=lmivar(2,[1 4]);   % define P2

%First LMI: X=P1
lmiterm([1 1 1 P1],A,1,'s');
lmiterm([1 1 1 P2],B2,1,'s');
lmiterm([1 1 1 0],gama^(-2)*B1*B1');

lmiterm([1 2 1 P1],C1,1);
lmiterm([1 2 1 P2],D12,1);

lmiterm([1 2 2 0],-1);   %-I<0
%Second LMI
lmiterm([2 1 1 P1],-1,1);

LMIs=getlmis;

[tmin,feasolution]=feasp(LMIs);

if tmin>0
   X=[];Y=[];
else   
% Solving P1,P2
   P1=dec2mat(LMIs,feasolution,1);   %P1
   P2=dec2mat(LMIs,feasolution,2);   %P2
end

K=P2*inv(P1)
%K=[36.3149 1.8765 6.3851 3.6704];