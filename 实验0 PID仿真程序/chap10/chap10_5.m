%GA(Generic Algorithm) to Optimize Online PID Control
clear all;
close all;
Size=120;
CodeL=2;

MinX(1)=9*ones(1);MaxX(1)=12*ones(1);
MinX(2)=0.20*ones(1);MaxX(2)=0.30*ones(1);

Kpid(:,1)=MinX(1)+(MaxX(1)-MinX(1))*rand(Size,1);
Kpid(:,2)=MinX(2)+(MaxX(2)-MinX(2))*rand(Size,1);

BsJ=0;
J=0;
x=zeros(1,2);
xi=zeros(1,2);
xk=zeros(1,2);
ts=0.001;

error_1=0;

BestS=zeros(2,1);
for k=1:1:100
    k
time(k)=k*ts;
yd(k)=1;

%u(k)=10*x(1)+0.2*x(2);   %Test PI:  good results
u(k)=BestS(1)*x(1)+BestS(2)*x(2);
para=u(k);
tSpan=[0 ts];

[tt,xx]=ode45('chap10_5plant',tSpan,xk,[],para);
xk=xx(length(xx),:);
y(k)=xk(1);
   
error(k)=yd(k)-y(k);
x(1)=error(k);                 % Calculating P
x(2)=(error(k)-error_1)/ts;    % Calculating D

error_1=error(k);

B=0;   
G=10;
for kg=1:1:G    %Era evolution
   
%****** Step 1 : Evaluate BestJ ******
for i=1:1:Size
   
Kpidi=Kpid(i,:);
ui(i)=Kpidi(1)*x(1)+Kpidi(2)*x(2);

para=ui(i);
[tt,xxi]=ode45('chap10_5plant',tSpan,xk,[],para);
yi(i)=xxi(length(xxi),1);

errori(i)=yd(k)-yi(i);
du(i)=ui(i)-u(k);
de(i)=(errori(i)-error(k))/ts;
alfap=0.95;
betap=0;

if abs(error(k))<=0.50
   betap=0.05;
end
J=alfap*abs(errori(i))+betap*abs(de(i));

B=J;
if errori(i)<0
   B=B+100*abs(errori(i));
end

BsJi(i)=B;
 
[OderJi,IndexJi]=sort(BsJi);
BestJ(kg)=OderJi(1);
BJ=BestJ(kg);
Ji=BsJi+1e-10;    %Avoiding deviding zero

fi=1./Ji;
%Cm=max(Ji);
%fi=Cm-Ji;
end    %End of a Size!!!!!!!!!!

   [Oderfi,Indexfi]=sort(fi);    %Arranging fi small to bigger
   Bestfi=Oderfi(Size);          %Let Bestfi=max(fi)
   BestS=Kpid(Indexfi(Size),:);  %Let BestS=E(m), m is the Indexfi belong to max(fi)
%****** Step 2 : Select and Reproduct Operation******
   fi_sum=sum(fi);
   fi_Size=(Oderfi/fi_sum)*Size;
   
   fi_S=floor(fi_Size);                    % Selecting Bigger fi value
   r=Size-sum(fi_S);
   
   Rest=fi_Size-fi_S;
   [RestValue,Index]=sort(Rest);
   
   for i=Size:-1:Size-r+1
      fi_S(Index(i))=fi_S(Index(i))+1;     % Adding rest to equal Size
   end

   kr=1;
   for i=Size:-1:1       % Select the Sizeth and Reproduce firstly  
      for j=1:1:fi_S(i)  
       TempE(kr,:)=Kpid(Indexfi(i),:);       % Select and Reproduce 
         kr=kr+1;                            % kr is used to reproduce
      end
   end
   E=TempE;
%************ Step 3 : Crossover Operation ************
    Pc=0.90;
    for i=1:2:(Size-1)
          temp=rand;
      if Pc>temp                      %Crossover Condition
          alfa=rand;
          TempE(i,:)=alfa*Kpid(i+1,:)+(1-alfa)*Kpid(i,:);  
          TempE(i+1,:)=alfa*Kpid(i,:)+(1-alfa)*Kpid(i+1,:);
      end
    end
    TempE(Size,:)=BestS;
    Kpid=TempE;
%************ Step 4: Mutation Operation **************
Pm=0.20-[1:1:Size]*(0.01)/Size;       %Bigger fi,smaller Pm
Pm_rand=rand(Size,CodeL);
Mean=(MaxX + MinX)/2; 
Dif=(MaxX-MinX);

   for i=1:1:Size
      for j=1:1:CodeL
         if Pm(i)>Pm_rand(i,j)        %Mutation Condition
            TempE(i,j)=Mean(j)+Dif(j)*(rand-0.5);
         end
      end
   end
%Guarantee TempE(Size,:) belong to the best individual
TempE(Size,:)=BestS;
Kpid=TempE;
end   %End of kg
kph(k)=BestS(1);
kdh(k)=BestS(2);
BestS
end    %End of k
figure(1);
plot(time,yd,'r',time,y,'b:','linewidth',2);
xlabel('Time(s)');ylabel('yd,y');
legend('Ideal position signal','Position signal tracking');
figure(2);
plot(time,u,'r','linewidth',2);
xlabel('Time(s)');ylabel('u');
figure(3);
subplot(211);
plot(time,kph,'r','linewidth',2);
xlabel('Time(s)');ylabel('kp change');
subplot(212);
plot(time,kdh,'r','linewidth',2);
xlabel('Time(s)');ylabel('kd change');