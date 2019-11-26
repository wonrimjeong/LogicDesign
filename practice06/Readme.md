# Lab 10

## 실습 내용

### **리모콘 수신 모듈**



: GitHub에 제공된 소스코드 사용

: top module (top) 만 채워서 설계

: Testbench 이용하여 신호입력 후 wave로 확인
-wave 에서 Leader Code와 32bit Data code 확인

###  **FPGA 이용하여 리모콘 수신신호 확인**

### **wave 캡쳐 에 대한 설명**

처음 Leader code에서 cnt_h가 8999와 599만큼 간 후에 Custom code 발생
Data code의 cnt32가 32만큼 간 후에 종료 

### **동작원리 설명**
seq_rx가 2'b00일 때 모두 low인 상태
				2'b01일 때 현재 high가 들어온 상태
				2'b11일 때 모두 high인 상태
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzEzNzgyNDYzLC0xNTk3NjY1Mjc4LDU0Mz
g1MTIwLDEyNjgzNTU0NzQsMTcyNTE4MDIwOSwtMzE0MTIxNDQ3
LC0xOTA0NzgwMjMxXX0=
-->