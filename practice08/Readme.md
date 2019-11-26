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
Data code의 cnt32가 32만큼 
```verilog
reg		o_sec_clk		;
reg		o_min_clk		;
always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = ~i_sw2;
					o_min_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = 1'b0;
					o_min_clk = ~i_sw2;
				end
			endcase
		end
	endcase
end
```


### **Project Guide : 질의응답불가**

: 시:분:초에 대한 디지털 시계 완성

: 설정모드에서 7-segment의 dp를 활용한 설계

- 예)초 설정 시 - 초 부분의 dp led를 점등

: Blink 모드개발

- 설정모드에서 설정부분을 깜빡이게 Display
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzk2NTAzNTU1LDU0Mzg1MTIwLDEyNjgzNT
U0NzQsMTcyNTE4MDIwOSwtMzE0MTIxNDQ3XX0=
-->