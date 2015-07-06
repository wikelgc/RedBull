//chap14_3.cpp
//Real-time PID Control
//Options->Linker->Libraries->Graphics Library
//Copy c:\Borlandc\bgi\*.bgi files to the current directory
//Copy the H file "chap14_3.h" to \include directory
//Set:(1)c:\borlandc\include;(2)c:\borlandc\lib;
#include <math.h>       //Using sin()
#include <conio.h>      //Using clrscr() and getch() and kbhit()
#include <graphics.h>
#include <stdio.h>      //Using sprintf()
#include <dos.h>        //Using _disable() and _enable()
#include <string.h>
#include <bios.h>       //Specially for std_fun bioskey()
#include <stdlib.h>     //Using exit()
#include <chap10_3.h>   //Interupt parameters

#define OUTPORT outportb
#define INPORT  inportb
#define T        500
#define DD_PORT 0x380    //D/D board base address

int channel=1;            //three frame: 0:inner; 1:middle; 2:outter
int Signal=1;             //Sine Signal
//int Signal=2;           //Step Signal

double PositionCommand[TIMER_RATIO];
double Line1[TIMER_RATIO];
double CurrentPosition[TIMER_RATIO];
double Line2[TIMER_RATIO];

double A,F;
double u=0.0,ts=0.001;
double pi=3.14159265358979;
double timezt=0;
int flag=0;
unsigned short    UpdateFlag=0;
double mStep,mStep_1,Step,SaveStep=0;  //mStep_1(t)=mStep(t-10)
//mStep must defined double
unsigned short    ItemNum;
unsigned short    TimerCount;
unsigned long     Counter;

unsigned short    flagF5;
unsigned short    FinishSimulate;
FILE *xyz;

#define DD_PORT  0x380   //Inner frame
void ResetShuXianBiao()
{
     outport(DD_PORT,0x0);
     outport(DD_PORT,0xf);
     outport(DD_PORT+4,0x0);
     outport(DD_PORT+4,0xf);
     outport(DD_PORT+8,0x0);
     outport(DD_PORT+8,0xf);
}

double angle_1;
double ReadD_D(unsigned short channel)
{
	unsigned short Data_H1,Data_L1,Data_H2,Data_L2;
	long int data,angle_degree,angle_minute,angle_second;
	double angle,angle1,errory;
	do {
	     Data_L1=inport(DD_PORT+4*channel);
	     Data_H1=inport(DD_PORT+2+4*channel);
	     Data_L2=inport(DD_PORT+4*channel);
	     Data_H2=inport(DD_PORT+2+4*channel);
	    }while((Data_L1!=Data_L2)||(Data_H1!=Data_H2));

	 data=((Data_H1 & 0x3f)*65536+Data_L1);
	 angle1=data*0.9;       //Second per data
	 if((Data_H1 & 0x80) ==0x80)  //nagative if Data_H.7 ==1
	     angle1=-angle1;
	 angle=angle1/3600.0;   //Change from Second to degree
	 return(angle);
}

#define Da_Board  0x1A0
void Write_DA(double dValue, int channel)
{
   unsigned int hi,low,hilow;
   int state;
   double voltage;
   voltage=dValue;
   if(voltage>2.0)voltage=2.0;
   if(voltage<-2.0)voltage=-2.0;
   hilow=(unsigned int)((voltage)*65535/20);

   hi=hilow&0xff00;
   hi=hi>>8;
   low=hilow&0xff;

   outportb(Da_Board+0,channel); //Select channel
   do
	{
	 state=(inportb(Da_Board+0))&0x80;
	} while(state==1);    //read bit D7; if D7=0 write data

   outportb(Da_Board+1,low);   //write low byte
   outportb(Da_Board+2,hi);    //write high byte
   outportb(Da_Board+3,0);     //start da
}

int KbGetKey(int *ScanCode)
{
     int Key;
     int KeyCode;
     Key=bioskey(0);
     if((Key&0x00ff)==0)
     {
	 KeyCode=0;
	 *ScanCode=(Key>>8)&127;
     }
     else
     {
	 KeyCode=Key&0xff;
	 *ScanCode=0;
     }
     return(KeyCode);
}

int SavedFlag,SaveCounter;
void SetupKeyReaction(void)
{
     int Key,Scan;
     if(kbhit())
     {
	  Key=KbGetKey(&Scan);
	 if (Key==KB_C_N_F5 && Scan==KB_S_N_F5)
		{
		 SavedFlag=1;
		 SaveCounter=0;
		}
	 if(Key==KB_C_A_X && Scan==KB_S_A_X)
	 {
	     FinishSimulate = 1;
	 }
     }
}

double huge DataSaved[DATA_DIMENTION][DATA_LENGTH];
void DataSaveRoutine( long int SaveSpan)
{
	if(SavedFlag==1)
	  {
	    if((SaveCounter<=SaveSpan*DATA_LENGTH)) //DATA_LENGTH is Defined by chap10_3.h
	     {
		int SaveIndex = SaveCounter/SaveSpan;
//Save data(rin,yout) to xyz.dat
		DataSaved[0][SaveIndex]=PositionCommand[ItemNum];
		DataSaved[1][SaveIndex]=CurrentPosition[ItemNum];
	     }
	   SaveCounter++;
	   if(SaveCounter>=SaveSpan*DATA_LENGTH) { SavedFlag=0; SaveCounter=0; }
	  }
	 if(SavedFlag==0)  SaveCounter=0;
}

int M;
double yout,error,derror;
double u_1=0,u_2=0,y_1=0,y_2=0,error_1=0,error_2=0,ei=0;
double Control(double rin,unsigned short channel)
{
M=2;
if( M==1)    //Realtime control
{
yout=ReadD_D(channel);   //Read realtime data
CurrentPosition[ItemNum]=yout;
}
if( M==2 )   //Simulation control
{
yout=1.94*y_1-0.94*y_2+0.0008674*u_1+0.0008503*u_2;
}

CurrentPosition[ItemNum]=yout;
yout=CurrentPosition[ItemNum];

F=0.50;
A=0.010; if(A==0.0) { A=0.0001; }
rin=A*sin(F*2*pi*timezt);
error=rin-yout;

u=10.0*error+1.0*derror+0*ei;
//Update Parameters
y_2=y_1;y_1=yout;
u_2=u_1;u_1=u;
error_2=error_1;
error_1=error;

return u;
}
int Cycles=5;  //Display cycle times
void DynamicDisplay()
{
     //Make a window
     char   strA[50];
     int    i,Spoint;
     int    bottom,middle,top,right,left;
     bottom=300;middle=200;top=100;left=50;right=550;
     setcolor(RED);
     outtextxy(270,50,"PID Controller");
     line(left,top,left,bottom);        //lineleft
     sprintf(strA,"%f",A*6.0/5.0);
     outtextxy(36,top-10,strA);
     line(left,top,right,top);          //linetop
     outtextxy(36,middle,"0");
     line(left,middle,right,middle);    //linemiddle
     sprintf(strA,"%f",-A*6.0/5.0);
     outtextxy(36,bottom+5,strA);
     line(left,bottom,right,bottom);    //linedown
     line(right,top,right,bottom);      //lineright

//Make Curve Range
     for(i=0;i<TIMER_RATIO;i++)   //Plot 10 points once a time
     {
	 Spoint=mStep_1/Step-TIMER_RATIO+i;  //Start point

	 Spoint=Spoint/Cycles;  //25000/(10*T)=One Cycle
	 if(Spoint%T==0)
	 {
	     clrscr();
	 }
	 putpixel(Spoint-(Spoint/T)*T+50,-100*5.0/6.0*
			 (Line1[i]/A)+200,BLUE);    //Practical output
	 putpixel(Spoint-(Spoint/T)*T+50,-100*5.0/6.0*
			 (Line2[i]/A)+200,RED);     //Ideal output
	 putpixel(Spoint-(Spoint/T)*T+50,-100*5.0/6.0*
			  u+200,BLACK);             //Control output
     }
}

void IniTimer( unsigned char timer_mode ) //Initial 8253
{
	unsigned char value;
	_disable();

//Seting control word
	OUTPORT(TIMER_BASE+3,timer_mode);
	value = TIMER_VALUE ;        //Low 8 bits
	OUTPORT( TIMER_BASE , value );
	value = TIMER_VALUE / 256 ;  //High 8 bits
	OUTPORT( TIMER_BASE , value );
	_enable();
}

void interrupt ( *OldIrqVect )( __CPPARGS );
void interrupt TimerIrqVect( __CPPARGS )   //Interupt processing
{
    unsigned short i;
    _disable();
    ItemNum = Counter%TIMER_RATIO;

    if(Counter%20000==0)
    {
	Counter=0;
	SaveStep=SaveStep+mStep;
	mStep=0;
    }
    mStep += Step;          //k*ts: TIMER_CYCLE / TIMER_RATIO;

if (Signal==1)   //Dynamic Signal
{   PositionCommand[ItemNum]=A*sin(F*2*pi*mStep);  }
if (Signal==2)   //Static Signal
{   PositionCommand[ItemNum]=A;  }

    u=Control(PositionCommand[ItemNum],channel);

    Write_DA(u,channel);
    DataSaveRoutine(1);

    Counter++;
    if((--TimerCount)==0)   //Updating 1 times while interupted by 10 times
    {
	 UpdateFlag=1;
	 mStep_1=mStep;
	 TimerCount=TIMER_RATIO;
    }
     OUTPORT(EOI,0x20); //OCW2 value:0010 0000
    _enable();
}

void IrqHook( unsigned short irqnumber, void interrupt ( *newVect )( __CPPARGS ) )
{
	_disable();
	OldIrqVect = getvect ( irqnumber );
	setvect ( irqnumber , newVect );
	_enable();
}

void ReleaseHardware()
{
	_disable();
	setvect (Irqnumber,OldIrqVect);
	Write_DA(0.0,0);
	Write_DA(0.0,1);
	Write_DA(0.0,2);
	_enable();
}

main(void)
{
     int i,j,k;
     unsigned char timer0_mode,strtime[10];
     int driver,mode;
     driver=DETECT;
     initgraph(&driver,&mode,"");
     timer0_mode=T8253_MODE_3|T8253_CHANNEL_0|
		 T8253_BIN_MODE|T8253_LOW_FIRST;  //8253 timer setting

     Step=TIMER_CYCLE/TIMER_RATIO;        //Step=0.01/10=0.001s=ts
     mStep=0;
     mStep_1=0;
     Counter=0;
     TimerCount=TIMER_RATIO;

     clrscr();
     ResetShuXianBiao();
//Using interupt function
     IniTimer(timer0_mode);  //8253 timer setting
     IrqHook(Irqnumber,TimerIrqVect);

     while(1)                //1 is true
     {
	 timezt=SaveStep+mStep;
	 if(UpdateFlag==1)
	 {
	     UpdateFlag=0;
	     for(i=0;i<TIMER_RATIO;i++)
	     {
		 Line1[i]=PositionCommand[i];
		 Line2[i]=CurrentPosition[i];
	      }
	     SetupKeyReaction();
	     DynamicDisplay();
	  }

	 sprintf(strtime,"%f",timezt);
	 bar(260,380,360,360);
	 outtextxy(285,385,"time(s)");
	 outtextxy(280,370,strtime);

//	 if(kbhit()) {  break; } //Break by any key
	 if(FinishSimulate==1)   //Break by "ALT+X"
	  break;
     }//End of for{} loop

//Open xyz.dat for save data
  if ((xyz = fopen("xyz.dat", "w"))== NULL)
       {
	 printf("Cannot open output file xyz.dat.\n");
	 exit( 1 );
       }
//xyz=fopen("xyz.dat","w");

  for( i=0;i<DATA_LENGTH;i++)
	{
	 for( j=0; j<DATA_DIMENTION; j++)
	     {
	      fprintf(xyz," %10.6f ",DataSaved[j][i]);
	     }
	 fprintf(xyz,"\n");
	}
fclose(xyz);

ReleaseHardware();   //Clear all output u
getch();   //Any key to exit
closegraph();
//Restores the original video mode detected by initgraph
restorecrtmode();
return 0;
}  //End of main{}