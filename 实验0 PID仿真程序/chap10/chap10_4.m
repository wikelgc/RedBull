%GA(Generic Algorithm) Program to optimize Parameters of PID
clear all;
close all;
global yd y timef

G=100;
Size=30;
CodeL=10;

MinX(1)=zeros(1);
MaxX(1)=20*ones(1);
MinX(2)=zeros(1);
MaxX(2)=1.0*ones(1);
MinX(3)=zeros(1);
MaxX(3)=1.0*ones(1);

E=round(rand(Size,3*CodeL));    %Initial Code!

BsJ=0;

for kg=1:1:G
time(kg)=kg;
    
for s=1:1:Size
m=E(s,:);
y1=0;y2=0;y3=0;

m1=m(1:1:CodeL);
for i=1:1:CodeL
   y1=y1+m1(i)*2^(i-1);
end
Kpid(s,1)=(MaxX(1)-MinX(1))*y1/1023+MinX(1);

m2=m(CodeL+1:1:2*CodeL);
for i=1:1:CodeL
   y2=y2+m2(i)*2^(i-1);
end
Kpid(s,2)=(MaxX(2)-MinX(2))*y2/1023+MinX(2);

m3=m(2*CodeL+1:1:3*CodeL);
for i=1:1:CodeL
   y3=y3+m3(i)*2^(i-1);
end
Kpid(s,3)=(MaxX(3)-MinX(3))*y3/1023+MinX(3);

%****** Step 1 : Evaluate BestJ ******
Kpidi=Kpid(s,:);
    
[Kpidi,BsJ]=chap10_4plant(Kpidi,BsJ);

 BsJi(s)=BsJ;   
 end
 
[OderJi,IndexJi]=sort(BsJi);
BestJ(kg)=OderJi(1);
BJ=BestJ(kg);
Ji=BsJi+1e-10;

   fi=1./Ji;
%  Cm=max(Ji);
%  fi=Cm-Ji;        %Avoiding deviding zero
   
   [Oderfi,Indexfi]=sort(fi);         %Arranging fi small to bigger
%   Bestfi=Oderfi(Size);               %Let Bestfi=max(fi)
%   BestS=Kpid(Indexfi(Size),:);     %Let BestS=E(m), m is the Indexfi belong to max(fi)

Bestfi=Oderfi(Size);         % Let Bestfi=max(fi)
BestS=E(Indexfi(Size),:);   % Let BestS=E(m), m is the Indexfi belong to max(fi)

kg   
BJ
BestS;

%****** Step 2 : Select and Reproduct Operation******
   fi_sum=sum(fi);
   fi_Size=(Oderfi/fi_sum)*Size;
   
   fi_S=floor(fi_Size);        %Selecting Bigger fi value
   
   r=Size-sum(fi_S);
   Rest=fi_Size-fi_S;
   [RestValue,Index]=sort(Rest);
   for i=Size:-1:Size-r+1
      fi_S(Index(i))=fi_S(Index(i))+1;     % Adding rest to equal Size
   end

   
   kk=1;
   for i=1:1:Size
      for j=1:1:fi_S(i)        %Select and Reproduce 
       TempE(kk,:)=E(Indexfi(i),:);  
         kk=kk+1;              %kk is used to reproduce
      end
   end
   
E=TempE;   
%************ Step 3 : Crossover Operation ************
pc=0.60;
n=ceil(20*rand);
for i=1:2:(Size-1)
    temp=rand;
    if pc>temp                 %Crossover Condition
    for j=n:1:20
        TempE(i,j)=E(i+1,j);
        TempE(i+1,j)=E(i,j);
    end
    end
end
TempE(Size,:)=BestS;
E=TempE;
   
%************ Step 4: Mutation Operation **************
%pm=0.001;
pm=0.001-[1:1:Size]*(0.001)/Size; %Bigger fi, smaller pm
%pm=0.0;    %No mutation
%pm=0.1;    %Big mutation

   for i=1:1:Size
      for j=1:1:3*CodeL
         temp=rand;
         if pm>temp               %Mutation Condition
            if TempE(i,j)==0
               TempE(i,j)=1;
            else
               TempE(i,j)=0;
            end
        end
      end
   end
%Guarantee TempE(Size,:) belong to the best individual
TempE(Size,:)=BestS;      
E=TempE;
%*******************************************************
end
Bestfi
BestS
Kpidi
Best_J=BestJ(G)
figure(1);
plot(time,BestJ,'r','linewidth',2);
xlabel('Times');ylabel('Best J');
figure(2);
plot(timef,yd,'r',timef,y,'b:','linewidth',2);
xlabel('Time(s)');ylabel('yd,y');
legend('Ideal position signal','Position signal tracking');