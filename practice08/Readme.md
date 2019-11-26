# Lab 10

## 실습 내용

### **리모콘 수신 모듈**

![](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/figs/block_diagram.png)

: GitHub에 제공된 소스코드 사용

: top module (top) 만 채워서 설계

: Testbench 이용하여 신호입력 후 wave로 확인
wave 에서 L

### **FPGA**

: 스위치의 Bounce 현상에대해관찰

: 코드를 수정하여 Debounce적용후 스위치 테스트 (Controller 부분 수정)



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
eyJoaXN0b3J5IjpbLTk5NjA0MDA2LDEyNjgzNTU0NzQsMTcyNT
E4MDIwOSwtMzE0MTIxNDQ3XX0=
-->