#include "sys.h"	
#include "delay.h"	
#include "led.h" 
#include "beep.h" 
//ALIENTEKս��STM32������ʵ��2
//������ʵ��  
//����֧�֣�www.openedv.com
//������������ӿƼ����޹�˾ 
 int main(void)
 {
	delay_init();	    	 //��ʱ������ʼ��	  
	LED_Init();		  	 	//��ʼ����LED���ӵ�Ӳ���ӿ�
	BEEP_Init();         	//��ʼ���������˿�
	while(1)
	{
		LED0=0;
		LED1=1;
		BEEP=0;		  
		delay_ms(300);//��ʱ300ms
		LED0=1;
		LED1=0;		
		BEEP=1;  
		delay_ms(300);//��ʱ300ms
	}
 }

