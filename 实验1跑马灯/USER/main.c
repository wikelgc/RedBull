#include "led.h"
#include "delay.h"
#include "sys.h"
//ALIENTEK战舰STM32开发板实验1
//跑马灯实验  
//技术支持：www.openedv.com
//广州市星翼电子科技有限公司
 int main(void)
 {	
	delay_init();	    //延时函数初始化	  
	LED_Init();		  	//初始化与LED连接的硬件接口
	 
	while(1)
	{
		//LED 0 亮，1 灭
		LED1=0;
		LED2=0;
		LED3=0;
		LED4=0;
		LED5=0;
		delay_ms(300);	 //延时300ms
		LED1=1;
		LED2=1;
		LED3=1;
		LED4=1;
		LED5=1;
		delay_ms(600);	//延时300ms
	}
 }

