#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "lcd.h"
#include "usart.h"
//ALIENTEKս��STM32������ʵ��13
//TFTLCD��ʾʵ��  
//����֧�֣�www.openedv.com
//������������ӿƼ����޹�˾ 
 	
 int main(void)
 {	 
 	u8 x=0;
	u8 lcd_id[12];			//���LCD ID�ַ���
	delay_init();	    	 //��ʱ������ʼ��	  
	NVIC_Configuration(); 	 //����NVIC�жϷ���2:2λ��ռ���ȼ���2λ��Ӧ���ȼ�
	uart_init(9600);	 	//���ڳ�ʼ��Ϊ9600
 	LED_Init();			     //LED�˿ڳ�ʼ��
	LCD_Init();
	POINT_COLOR=RED;
	sprintf((char*)lcd_id,"LCD ID:%04X",lcddev.id);//��LCD ID��ӡ��lcd_id���顣				 	
  	while(1) 
	{		 
//		switch(x)
//		{
//			case 0:LCD_Clear(WHITE);break;
//			case 1:LCD_Clear(BLACK);break;
//			case 2:LCD_Clear(BLUE);break;
//			case 3:LCD_Clear(RED);break;
//			case 4:LCD_Clear(MAGENTA);break;
//			case 5:LCD_Clear(GREEN);break;
//			case 6:LCD_Clear(CYAN);break;

//			case 7:LCD_Clear(YELLOW);break;
//			case 8:LCD_Clear(BRRED);break;
//			case 9:LCD_Clear(GRAY);break;
//			case 10:LCD_Clear(LGRAY);break;
//			case 11:LCD_Clear(BROWN);break;
//		}
//		POINT_COLOR=RED;	  
		LCD_ShowString(30,50,200,16,16,"WarShip STM32 ^_^");	
		LCD_ShowString(30,66,200,16,16,"TFTLCD TEST");	
		LCD_ShowString(30,82,200,16,16,"ATOM@ALIENTEK");
 		LCD_ShowString(30,110,200,16,16,lcd_id);		//��ʾLCD ID	      					 
		LCD_ShowString(30,130,200,16,16,"2012/9/5");	      					 
	    //x++;
		if(x==12)x=0;
		LED0=!LED0;					 
		delay_ms(1000);	
	} 
}
