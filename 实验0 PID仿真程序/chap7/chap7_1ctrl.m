function [sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
thd=u(1);
dthd=0;
ddthd=0;

th=u(2);
q1=u(3);
q2=u(4);

dth=u(5);
dq1=u(6);
dq2=u(7);

q=[q1 q2]';
dq=[dq1 dq2]';
e=th-thd;

kp=100;
kd=1000;
xite=4.0;
xite=0;
ut=-kp*e-kd*dth-xite*sign(dth);

sys(1)=ut;