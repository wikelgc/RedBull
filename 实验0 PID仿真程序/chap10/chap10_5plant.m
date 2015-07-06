function dx=PlantModel(t,x,flag,para)
dx=zeros(2,1);
u=para;
dx(1)=x(2);
dx(2)=-50*x(2)+400*u;