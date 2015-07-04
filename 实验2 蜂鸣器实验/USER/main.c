#include "sys.h"	
#include "delay.h"	
#include "led.h" 
#include "beep.h" 
//ALIENTEK战舰STM32开发板实验2
//蜂鸣器实验  
//技术支持：www.openedv.com
//广州市星翼电子科技有限公司 
 int main(void)
 {
	delay_init();	    	 //延时函数初始化	  
	LED_Init();		  	 	//初始化与LED连接的硬件接口
	BEEP_Init();         	//初始化蜂鸣器端口
	while(1)
	{
		LED0=0;
		LED1=1;
		BEEP=0;		  
		delay_ms(300);//延时300ms
		LED0=1;
		LED1=0;		
		BEEP=1;  
		delay_ms(300);//延时300ms
	}
 }

