%GA(Generic Algorithm) Program to predict Parameters of Friction
clear all;
close all;
global yd y timef F

Size=30;
F=2;
if F==1
   CodeL=1;
   MinX=zeros(CodeL,1);
   MaxX=1.0*ones(CodeL,1);
end
if F==2
   CodeL=2;
   MinX=zeros(CodeL,1);
   MaxX=2.0*ones(CodeL,1);
end
for i=1:1:CodeL
    kxi(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

G=50;
BsJ=0;
for kg=1:1:G
    time(kg)=kg;
%****** Step 1:Evaluate BestJ ******
for i=1:1:Size
    kx=kxi(i,:);
    
[kx,BsJ]=chap10_6plant(kx,BsJ);

BsJi(i)=BsJ;   
end
 
[OderJi,IndexJi]=sort(BsJi);
BestJ(kg)=OderJi(1);
BJ=BestJ(kg);
Ji=BsJi+1e-10;

   fi=1./Ji;
%  Cm=max(Ji);
%  fi=Cm-Ji;                           %Avoiding deviding zero
   
   [Oderfi,Indexfi]=sort(fi);      %Arranging fi small to bigger
   Bestfi=Oderfi(Size);              %Let Bestfi=max(fi)
%Let BestS=E(m), m is the Indexfi belong to max(fi)
   BestS=kxi(Indexfi(Size),:);     
   
   kg   
   BJ
   BestS
   kx
%****** Step 2 : Select and Reproduct Operation******
   fi_sum=sum(fi);
   fi_Size=(Oderfi/fi_sum)*Size;
   
   fi_S=floor(fi_Size);                %Selecting Bigger fi value
   r=Size-sum(fi_S);
   
   Rest=fi_Size-fi_S;
   [RestValue,Index]=sort(Rest);
   
   for i=Size:-1:Size-r+1
       fi_S(Index(i))=fi_S(Index(i))+1; %Adding rest to equal Size
   end

   k=1;
   for i=Size:-1:1            %Select the Sizeth and Reproduce first!  
      for j=1:1:fi_S(i)       %Notice: If i=1:1:Size then k plus meaningless
       TempE(k,:)=kxi(Indexfi(i),:);    %Select and Reproduce 
         k=k+1;                              %k is used to reproduce
      end
   end
   E=TempE;
%************ Step 3 : Crossover Operation ************
    Pc=0.90;
    for i=1:2:(Size-1)
          temp=rand;
      if Pc>temp                         %Crossover Condition
          alfa=rand;
          TempE(i,:)=alfa*kxi(i+1,:)+(1-alfa)*kxi(i,:);  
          TempE(i+1,:)=alfa*kxi(i,:)+(1-alfa)*kxi(i+1,:);
      end
    end
    TempE(Size,:)=BestS;
    kxi=TempE;
%************ Step 4: Mutation Operation **************
Pm=0.10-[1:1:Size]*(0.01)/Size;          %Bigger fi, smaller Pm
Pm_rand=rand(Size,CodeL);
Mean=(MaxX + MinX)/2; 
Dif=(MaxX-MinX);

   for i=1:1:Size
      for j=1:1:CodeL
         if Pm(i)>Pm_rand(i,j)           %Mutation Condition
            TempE(i,j)=Mean(j)+Dif(j)*(rand-0.5);
         end
      end
   end
%Guarantee TempE(Size,:) belong to the best individual
   TempE(Size,:)=BestS; 
   kxi=TempE;
%***************************************************************
end
Bestfi
BestS
Best_J=BestJ(G)
 
figure(1);
plot(timef,yd,'r',timef,y,'k:','linewidth',2);
xlabel('Time(s)');ylabel('yd,y');
legend('Ideal position signal','Position signal tracking');
figure(2);
plot(time,BestJ,'r','linewidth',2);
xlabel('Times');ylabel('Best J');