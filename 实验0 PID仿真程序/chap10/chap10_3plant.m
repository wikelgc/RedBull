function [Kpidi,BsJ]=pid_gaf(Kpidi,BsJ)
global yd y timef

ts=0.001;
sys=tf(400,[1,50,0]);  
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;
y_1=0.0;y_2=0.0;
x=[0,0,0]';
B=0;
error_1=0;
tu=1;
s=0;
P=100;

for k=1:1:P
   timef(k)=k*ts;
   yd(k)=1.0;
   
   u(k)=Kpidi(1)*x(1)+Kpidi(2)*x(2)+Kpidi(3)*x(3); 
   
   if u(k)>=10
      u(k)=10;
   end
   if u(k)<=-10
      u(k)=-10;
   end   
   y(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
   error(k)=yd(k)-y(k);
%------------ Return of PID parameters -------------
   u_2=u_1;u_1=u(k);
   y_2=y_1;y_1=y(k);
   
   x(1)=error(k);                % Calculating P
   x(2)=(error(k)-error_1)/ts;   % Calculating D
   x(3)=x(3)+error(k)*ts;        % Calculating I
   
   error_2=error_1;
   error_1=error(k);
if s==0
   if y(k)>0.95&y(k)<1.05
      tu=timef(k);
      s=1;
   end 
end
end

for i=1:1:P
   Ji(i)=0.999*abs(error(i))+0.01*u(i)^2*0.1;
   B=B+Ji(i);   
  if i>1   
   erry(i)=y(i)-y(i-1);
   if erry(i)<0
      B=B+100*abs(erry(i));
   end    
  end
end
BsJ=B+0.2*tu*10;