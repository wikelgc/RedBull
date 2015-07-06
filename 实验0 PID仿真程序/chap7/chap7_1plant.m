function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[0 0 0 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
thd=pi/3;qd1=0;qd2=0;

th=x(1);
q1=x(2);
q2=x(3);
ut=u(1);

J=3250;
F1=54;
F2=6;
w1=1.2;w2=3.4;
Ks1=0.01;Ks2=0.01;

M=[J F1 F2;F1 1 0;F2 0 1];
N=[0 0 0;0 2*Ks1*w1 0;0 0 2*Ks2*w2];
K=[0 0 0;0 w1^2 0;0 0 w2^2];

dt=0*3*sin(t);

x1=[x(1) x(2) x(3)]';
x2=[x(4) x(5) x(6)]';
B=[1 0 0]';

dx2=inv(M)*(-N*x2-K*x1+B*(ut-dt));
sys(1)=x2(1);   %th
sys(2)=x2(2);   %q1
sys(3)=x2(3);   %q2

sys(4)=dx2(1);   %dth
sys(5)=dx2(2);   %dq1
sys(6)=dx2(3);   %dq2
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);   %th
sys(2)=x(2);   %q1
sys(3)=x(3);   %q2
sys(4)=x(4);   %dth
sys(5)=x(5);   %dq1
sys(6)=x(6);   %dq2