%Adaptive PID control based on RBF Identification
clear all;
close all;

xite=0.5;
alfa=0.05;
beta=0.01;
x=[0,0,0]';

ci=zeros(3,6);
bi=10*ones(6,1);
w=0.10*ones(6,1);

h=[0,0,0,0,0,0]';
    
ci_1=ci;ci_3=ci_1;ci_2=ci_1;
bi_1=bi;bi_2=bi_1;bi_3=bi_2;
w_1=w;w_2=w_1;w_3=w_1;

u_1=0;y_1=0;
xc=[0,0,0]';
error_1=0;error_2=0;
kp0=0.01;ki0=0.01;kd0=0.01;

kp_1=kp0;
kd_1=kd0;
ki_1=ki0;

xitekp=0.15;
xitekd=0.15;
xiteki=0.15;

ts=0.001;
for k=1:1:1000
   time(k)=k*ts;
   yd(k)=1.0;
   y(k)=(-0.1*y_1+u_1)/(1+y_1^2);  %Nonlinear plant
   
   for j=1:1:6
      h(j)=exp(-norm(x-ci(:,j))^2/(2*bi(j)*bi(j)));
   end
   ym(k)=w'*h;

   d_w=0*w;
   for j=1:1:6
      d_w(j)=xite*(y(k)-ym(k))*h(j);
   end
   w=w_1+d_w+alfa*(w_1-w_2);
   
   d_bi=0*bi;
   for j=1:1:6
      d_bi(j)=xite*(y(k)-ym(k))*w(j)*h(j)*(bi(j)^-3)*norm(x-ci(:,j))^2;
   end
   bi=bi_1+ d_bi+alfa*(bi_1-bi_2);
   for j=1:1:6
     for i=1:1:3
      d_ci(i,j)=xite*(y(k)-ym(k))*w(j)*h(j)*(x(i)-ci(i,j))*(bi(j)^-2);
     end
   end
   ci=ci_1+d_ci+alfa*(ci_1-ci_2);
%%%%%%%%%%%%%%%%%%%%%%Jacobian%%%%%%%%%%%%%%%%%%%%%%%
  yu=0;
  for j=1:1:6
      yu=yu+w(j)*h(j)*(-x(1)+ci(1,j))/bi(j)^2;
  end
  dyu(k)=yu;
%%%%%%%%%%%%%%%%%%%%%%Start of Control system%%%%%%%%%%%%%%%%%%
   error(k)=yd(k)-y(k);
   kp(k)=kp_1+xitekp*error(k)*dyu(k)*xc(1);
   kd(k)=kd_1+xitekd*error(k)*dyu(k)*xc(2);
   ki(k)=ki_1+xiteki*error(k)*dyu(k)*xc(3);  
   if kp(k)<0
      kp(k)=0;
   end
   if kd(k)<0
      kd(k)=0;
   end
   if ki(k)<0
      ki(k)=0;
   end
   
   M=1;
   switch M
   case 1
   case 2  %Only PID Control
		kp(k)=kp0;
		ki(k)=ki0;     
		kd(k)=kd0;
   end
   du(k)=kp(k)*xc(1)+kd(k)*xc(2)+ki(k)*xc(3);
   u(k)=u_1+du(k);
%Return of parameters
   x(1)=du(k);
   x(2)=y(k);
   x(3)=y_1;

   u_1=u(k);
   y_1=y(k);
   
   ci_3=ci_2;
   ci_2=ci_1;
   ci_1=ci;
   
   bi_3=bi_2;
   bi_2=bi_1;
   bi_1=bi;
   
   w_3=w_2;
   w_2=w_1;
   w_1=w;
   
   xc(1)=error(k)-error_1;             %Calculating P
   xc(2)=error(k)-2*error_1+error_2;   %Calculating D
   xc(3)=error(k);                     %Calculating I
   
   error_2=error_1;
   error_1=error(k);
   
   kp_1=kp(k);
   kd_1=kd(k);
   ki_1=ki(k);  
end
if M==1
figure(1);
plot(time,yd,'r',time,y,'k:','linewidth',2);
xlabel('time(s)');ylabel('yd,y');
legend('ideal position','position tracking');
figure(2);
plot(time,y,'r',time,ym,'b','linewidth',2);
xlabel('time(s)');ylabel('y,ym');
figure(3);
plot(time,dyu,'r','linewidth',2);
xlabel('time(s)');ylabel('Jacobian value');
figure(4);
subplot(311);
plot(time,kp,'r','linewidth',2);
xlabel('time(s)');ylabel('kp');
subplot(312);
plot(time,ki,'r','linewidth',2);
xlabel('time(s)');ylabel('ki');
subplot(313);
plot(time,kd,'r','linewidth',2);
xlabel('time(s)');ylabel('kd');
elseif M==2
figure(1);
plot(time,yd,'r',time,y,'k:','linewidth',2);
xlabel('time(s)');ylabel('yd,y');
legend('ideal position','position tracking');
end