close all;
figure(1);
subplot(211);
plot(t,y(:,1),'r',t,y(:,2),'b:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
legend('ideal signal yd','tracking signal y');
subplot(212);
plot(t,y(:,1)-y(:,2),'r','linewidth',2);
xlabel('time(s)');ylabel('position tracking error');

figure(2);
subplot(211);
plot(t,d(:,1),'r',t,d1(:,1),'b:','linewidth',2);
xlabel('time(s)');ylabel('d and its estimate');
legend('d','Estimate d');
subplot(212);
plot(t,d(:,1)-d1(:,1),'r','linewidth',2);
xlabel('t/s');ylabel('d identification error');