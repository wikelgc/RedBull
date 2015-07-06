//chap14_3.h
#define TIMER_BASE      0x40    //Timer base address
#define TIMER_RATIO     10      //Display timer rate
#define TIMER_CYCLE     0.001*TIMER_RATIO    //Display time cycle

#define TIMER_VALUE 1193   //Define interupt time:sampling time(ts=0.001s)

#define Irqnumber 0x08     //Realtime interupt kind:Clock Interupt

//Save data parameters
#define DATA_DIMENTION          2
#define DATA_LENGTH             100

//8253 timer(P225)
#define T8253_MODE_0     	0x00
#define T8253_MODE_1     	0x02
#define T8253_MODE_2     	0x04
#define T8253_MODE_3     	0x06
#define T8253_MODE_4     	0x08
#define T8253_MODE_5     	0x0a

#define T8253_CHANNEL_0  	0x00
#define T8253_CHANNEL_1  	0x40
#define T8253_CHANNEL_2  	0x80

#define T8253_BIN_MODE   	0x00
#define T8253_BCD_MODE   	0x01

#define T8253_COUNT_LOCK 	0x00
#define T8253_COUNT_LOW  	0x10
#define T8253_COUNT_HI   	0x20
#define T8253_LOW_FIRST  	0x30

//8259 control(P197)
#define EOI			0x20

//Define key value//
#define KB_C_N_F4 0
#define KB_S_N_F4 62
#define KB_C_N_F5 0
#define KB_S_N_F5 63
#define KB_S_A_X 45
#define KB_C_A_X 0

#ifdef __cplusplus
	#define __CPPARGS ...
#endif
