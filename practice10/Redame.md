# Lab 10

## 실습 내용

### **리모콘 수신 모듈**



: GitHub에 제공된 소스코드 사용

: top module (top) 만 채워서 설계

: Testbench 이용하여 신호입력 후 wave로 확인
-wave 에서 Leader Code와 32bit Data code 확인

###  **FPGA 이용하여 리모콘 수신신호 확인**

### **동작원리와 wave 캡쳐 설명**
seq_rx가
 2'b00일 때 모두 low인 상태
			 	2'b01일 때 현재 high가 들어온 상태
				2'b11일 때 모두 high인 상태
				
Data code가 seg_rx가 2'b10이 되면 +1, 
총 32bit가 되면 data 한 사이클 완성

![](https://github.com/wonrimjeong/LogicDesign/blob/master/practice10/1.png)
처음 Leader code에서 
cnt_h가 8999와 599만큼 간 후에 Custom code 발생

![](https://github.com/wonrimjeong/LogicDesign/blob/master/practice10/2.png)
Data code의 cnt32가 32만큼 간 후에 종료 


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg2NjUxMTg5NF19
-->
