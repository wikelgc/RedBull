#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "beep.h"
//ALIENTEKս��STM32������ʵ��3
//��������ʵ��  
//����֧�֣�www.openedv.com
//������������ӿƼ����޹�˾ 	 
 int main(void)
 {
 	u8 t;
	delay_init();	    	 //��ʱ������ʼ��	  
 	LED_Init();			     //LED�˿ڳ�ʼ��
	KEY_Init();              //��ʼ���밴�����ӵ�Ӳ���ӿ�
	BEEP_Init();         	 //��ʼ���������˿�
	LED0=0;					 //�ȵ������
	while(1)
	{
 		t=KEY_Scan(0);		//�õ���ֵ
	   	if(t)
		{						   
			switch(t)
			{				 
				case KEY_UP:	//���Ʒ�����
					LED4=!LED4;
					LED1=!LED1;
					LED2=!LED2;
					LED3=!LED3;
					break;
				case KEY_LEFT:	//����LED0��ת
					LED1=!LED1;
					break;
				case KEY_DOWN:	//����LED1��ת	 
					LED2=!LED2;
					break;
				case KEY_RIGHT:	//ͬʱ����LED0,LED1��ת 
					LED3=!LED3;
					break;
			}
		}else delay_ms(10); 
	}	 
 }

