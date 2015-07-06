//chap14_2.cpp
//PID Realtime Control
#include <math.h>
int k;
double yout,u,rin,u_1=0,u_2=0,u_3=0,yout_1=0,yout_2=0,yout_3=0;
double Error_1=0.0,Error_2=0.0;
double ts=0.001;
double timek,pi=3.1415926;
double kp=0.50,ki=0.001,kd=0.001;
double Error,Perror,Ierror,Derror;

void main()
{
for (k=1;k<=5000;k++)
{
	 timek=k*ts;
	 rin=1;

//Practical Position Degree Signal at time k
yout=2.9063*yout_1-2.8227*yout_2+0.9164*yout_3+0.0853*0.001*u_1+0.3338*0.001*u_2+0.0817*0.001*u_3;

	 Error=yout-rin;

	 Perror=Error;                     //Getting P
	 Ierror= Ierror+Error*ts;          //Getting I
	 Derror=(Error-Error_1)/ts;        //Getting D

	 u=kp*Perror+ki*Ierror+kd*Derror;  //PID Control

//Update Parameters
	 Error_2=Error_1;
	 Error_1=Error;

	 yout_3=yout_2;
	 yout_2=yout_1;
	 yout_1=yout;   //Positional Signal at k-1
	 u_3=u_2;
	 u_2=u_1;
	 u_1=u;
	 }
	 }