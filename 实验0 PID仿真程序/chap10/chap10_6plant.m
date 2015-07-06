function [kx,BsJ]=pid_fm_gaf(kx,BsJ)
global yd y timef F
a=50;b=400;
ts=0.001; 
sys=tf(b,[1,a,0]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

u_1=0;u_2=0;
y_1=0;y_2=0;
e_1=0;
B=0;

G=400;
for k=1:1:G
   timef(k)=k*ts;
S=2;
if S==1
   fre=5;
   AA=0.5;
   yd(k)=AA*sin(2*pi*fre*k*ts);
end
if S==2
   yd(k)=1;
end

y(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
error(k)=yd(k)-y(k);  
derror(k)=(error(k)-e_1)/ts;
speed(k)=(y(k)-y_1)/ts;

if F==1  % Disturbance Signal: Coulomb Friction
   Ff(k)=0.8*sign(speed(k));     
end
if F==2  % Disturbance Signal: Coulomb & Viscous Friction
   Ff(k)=sign(speed(k))*(0.30*abs(speed(k))+1.50);
end

%kx=[0.3,1.5];   %Idea Identification

u(k)=50*error(k)+0.50*derror(k);   %PD control
u(k)=u(k)-Ff(k);    %Practical control input

if F==1
   Ffc(k)=kx*sign(speed(k)); %Friction Estimation
end
if F==2   %Friction Estimation
   Ffc(k)=sign(speed(k))*(kx(1)*abs(speed(k))+kx(2)); 
end

M=2;
if M==1   %PD without Friction compensation
    uc(k)=0;
elseif M==2     %PD with Friction compensation
    uc(k)=Ffc(k);
end
u(k)=u(k)+uc(k);
    
u_2=u_1;u_1=u(k);
y_2=y_1;y_1=y(k);
e_1=error(k);
end
for i=1:1:G
   Ji(i)=0.999*abs(error(i))+0.01*u(i)^2*0.1;
   B=B+Ji(i);   
   if error(i)<0    %Punishment
      B=B+10*abs(error(i));
   end
end
BsJ=B;