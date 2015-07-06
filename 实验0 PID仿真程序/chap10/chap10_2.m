%Generic Algorithm for function f(x1,x2) optimum
clear all;
close all;

Size=500;
CodeL=2;

MinX(1)=-2.048;
MaxX(1)=2.048;
MinX(2)=-2.048;
MaxX(2)=2.048;

E(:,1)=MinX(1)+(MaxX(1)-MinX(1))*rand(Size,1);
E(:,2)=MinX(2)+(MaxX(2)-MinX(2))*rand(Size,1);

G=500;
BsJ=0;

%*************** Start Running ***************
for kg=1:1:G
time(kg)=kg;

%****** Step 1 : Evaluate BestJ ******
for i=1:1:Size
xi=E(i,:);
x1=xi(1);
x2=xi(2);

F(i)=100*(x1^2-x2)^2+(1-x1)^2;

Ji=1./F;
BsJi(i)=min(Ji);

end
 
[OderJi,IndexJi]=sort(BsJi);
BestJ(kg)=OderJi(1);
BJ=BestJ(kg);
Ji=BsJi+1e-10;    %Avoiding deviding zero

fi=F;
   
   [Oderfi,Indexfi]=sort(fi);    %Arranging fi small to bigger
   Bestfi=Oderfi(Size);          %Let Bestfi=max(fi)
   BestS=E(Indexfi(Size),:);  %Let BestS=E(m), m is the Indexfi belong to max(fi)
   
   bfi(kg)=Bestfi;

   %kg   
   %BestS
%****** Step 2 : Select and Reproduct Operation******
   fi_sum=sum(fi);
   fi_Size=(Oderfi/fi_sum)*Size;
   
   fi_S=floor(fi_Size);                    % Selecting Bigger fi value
   %sum(fi_S)  %Before fill
   r=Size-sum(fi_S);
   Rest=fi_Size-fi_S;
   [RestValue,Index]=sort(Rest);
   
   for i=Size:-1:Size-r+1
      fi_S(Index(i))=fi_S(Index(i))+1;     % Adding rest to equal Size
   end
   %sum(fi_S)   %After fill

   k=1;
   for i=Size:-1:1       % Select the Sizeth and Reproduce firstly  
      for j=1:1:fi_S(i)  
       TempE(k,:)=E(Indexfi(i),:);      % Select and Reproduce 
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
          TempE(i,:)=alfa*E(i+1,:)+(1-alfa)*E(i,:);  
          TempE(i+1,:)=alfa*E(i,:)+(1-alfa)*E(i+1,:);
      end
    end
    TempE(Size,:)=BestS;
    E=TempE;
    
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
   E=TempE;
end
BestS
Bestfi

figure(1);
plot(time,BestJ,'k');
xlabel('Times');ylabel('Best J');

figure(2);
plot(time,bfi,'k');
xlabel('times');ylabel('Best F');