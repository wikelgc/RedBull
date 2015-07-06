%GA(Generic Algorithm) Program to optimize PID Parameters
clear all;
close all;
global yd y timef

Size=30;
CodeL=3;

MinX(1)=zeros(1);
MaxX(1)=20*ones(1);
MinX(2)=zeros(1);
MaxX(2)=1.0*ones(1);
MinX(3)=zeros(1);
MaxX(3)=1.0*ones(1);

Kpid(:,1)=MinX(1)+(MaxX(1)-MinX(1))*rand(Size,1);
Kpid(:,2)=MinX(2)+(MaxX(2)-MinX(2))*rand(Size,1);
Kpid(:,3)=MinX(3)+(MaxX(3)-MinX(3))*rand(Size,1);

G=100;
BsJ=0;

%*************** Start Running ***************
for kg=1:1:G
    time(kg)=kg;

%****** Step 1 : Evaluate BestJ ******
for i=1:1:Size
Kpidi=Kpid(i,:);
    
[Kpidi,BsJ]=chap10_3plant(Kpidi,BsJ);

BsJi(i)=BsJ;
end
 
[OderJi,IndexJi]=sort(BsJi);
BestJ(kg)=OderJi(1);
BJ=BestJ(kg);
Ji=BsJi+1e-10;    %Avoiding deviding zero

   fi=1./Ji;
%  Cm=max(Ji);
%  fi=Cm-Ji;                     
   
   [Oderfi,Indexfi]=sort(fi);    %Arranging fi small to bigger
   Bestfi=Oderfi(Size);          %Let Bestfi=max(fi)
   BestS=Kpid(Indexfi(Size),:);  %Let BestS=E(m), m is the Indexfi belong to max(fi)
   
   kg   
   BJ
   BestS
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

   k=1;
   for i=Size:-1:1       % Select the Sizeth and Reproduce firstly  
      for j=1:1:fi_S(i)  
       TempE(k,:)=Kpid(Indexfi(i),:);      % Select and Reproduce 
         k=k+1;                            % k is used to reproduce
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
Pm=0.10-[1:1:Size]*(0.01)/Size;       %Bigger fi,smaller Pm
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
end
Bestfi
BestS
Best_J=BestJ(G)
figure(1);
plot(time,BestJ,'r','linewidth',2);
xlabel('Times');ylabel('Best J');
figure(2);
plot(timef,yd,'r',timef,y,'b:','linewidth',2);
xlabel('Time(s)');ylabel('yd,y');
legend('Ideal position signal','Position signal tracking');