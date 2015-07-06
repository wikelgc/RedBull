close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,2),'b:','linewidth',2);
xlabel('time(s)');ylabel('angle tracking');
legend('ideal angle','practical angle');
subplot(212);
plot(t,x(:,5),'b:','linewidth',2);
xlabel('time(s)');ylabel('angle speed');

figure(2);
subplot(211);
plot(t,x(:,3),'r','linewidth',2);
xlabel('time(s)');ylabel(' Mode 1');
subplot(212);
plot(t,x(:,6),'r','linewidth',2);
xlabel('time(s)');ylabel('Mode 2');

figure(3);
subplot(211);
plot(t,x(:,4),'r','linewidth',2);
xlabel('time(s)');ylabel('speed of Mode 1');
subplot(212);
plot(t,x(:,7),'r','linewidth',2);
xlabel('time(s)');ylabel('speed of Mode 2');

figure(4);
plot(t,Th(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('Th');