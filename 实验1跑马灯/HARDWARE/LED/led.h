#ifndef __LED_H
#define __LED_H	 
#include "sys.h"
//////////////////////////////////////////////////////////////////////////////////	 
//������ֻ��ѧϰʹ�ã�δ��������ɣ��������������κ���;
//ALIENTEKս��STM32������
//LED��������	   
//����ԭ��@ALIENTEK
//������̳:www.openedv.com
//�޸�����:2012/9/2
//�汾��V1.0
//��Ȩ���У�����ؾ���
//Copyright(C) ������������ӿƼ����޹�˾ 2009-2019
//All rights reserved									  
//////////////////////////////////////////////////////////////////////////////////

//ս��
/*

#define LED0 PBout(5)// PB5
#define LED1 PEout(5)// PE5	
*/

/* ��ţ */

#define LED1 PFout(6)// PE5	
#define LED2 PFout(7)// PB5
#define LED3 PFout(8)// PE5	
#define LED4 PFout(9)// PB5
#define LED5 PFout(10)// PE5	

void LED_Init(void);//��ʼ��

		 				    
#endif
