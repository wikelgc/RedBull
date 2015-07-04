#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "beep.h"
//ALIENTEK战舰STM32开发板实验3
//按键输入实验  
//技术支持：www.openedv.com
//广州市星翼电子科技有限公司 	 
 int main(void)
 {
 	u8 t;
	delay_init();	    	 //延时函数初始化	  
 	LED_Init();			     //LED端口初始化
	KEY_Init();              //初始化与按键连接的硬件接口
	BEEP_Init();         	 //初始化蜂鸣器端口
	LED0=0;					 //先点亮红灯
	while(1)
	{
 		t=KEY_Scan(0);		//得到键值
	   	if(t)
		{						   
			switch(t)
			{				 
				case KEY_UP:	//控制蜂鸣器
					LED4=!LED4;
					LED1=!LED1;
					LED2=!LED2;
					LED3=!LED3;
					break;
				case KEY_LEFT:	//控制LED0翻转
					LED1=!LED1;
					break;
				case KEY_DOWN:	//控制LED1翻转	 
					LED2=!LED2;
					break;
				case KEY_RIGHT:	//同时控制LED0,LED1翻转 
					LED3=!LED3;
					break;
			}
		}else delay_ms(10); 
	}	 
 }

