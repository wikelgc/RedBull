#include "led.h"
#include "delay.h"
#include "sys.h"
//ALIENTEKս��STM32������ʵ��1
//�����ʵ��  
//����֧�֣�www.openedv.com
//������������ӿƼ����޹�˾
 int main(void)
 {	
	delay_init();	    //��ʱ������ʼ��	  
	LED_Init();		  	//��ʼ����LED���ӵ�Ӳ���ӿ�
	 
	while(1)
	{
		//LED 0 ����1 ��
		LED1=0;
		LED2=0;
		LED3=0;
		LED4=0;
		LED5=0;
		delay_ms(300);	 //��ʱ300ms
		LED1=1;
		LED2=1;
		LED3=1;
		LED4=1;
		LED5=1;
		delay_ms(600);	//��ʱ300ms
	}
 }

