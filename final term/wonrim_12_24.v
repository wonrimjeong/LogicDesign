module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_blink_seg,
		i_num);
		
parameter     OFF = 1'b0  ;
parameter     ON  = 1'b1  ;

output	[6:0]	 o_seg		     ;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	 [3:0]	 i_num		     ;
input         	i_blink_seg ;

reg	   [6:0]	 o_seg		     ;

always @(*) begin
  case(i_blink_seg)
    ON  : begin
     case(i_num) 
 		   4'd0 : o_seg = 7'b111_1110	; 
 		   4'd1 : o_seg = 7'b011_0000	; 
 		   4'd2 : o_seg = 7'b110_1101	; 
 		   4'd3 : o_seg = 7'b111_1001	; 
 		   4'd4 : o_seg = 7'b011_0011	; 
 		   4'd5 : o_seg = 7'b101_1011	; 
 		   4'd6 : o_seg = 7'b101_1111	; 
 		   4'd7 : o_seg = 7'b111_0000	; 
 		   4'd8 : o_seg = 7'b111_1111	; 
 		   4'd9 : o_seg = 7'b111_0011	; 
		   default : o_seg = 7'b000_0000	;
		  endcase 
    end
    OFF : begin
      o_seg = 7'b000_0000 ;
    end
  endcase
end

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;
	
endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
		o_seg,
		o_seg_dp,
		o_seg_enb,
		i_six_digit_seg,
		i_six_dp,
		clk,
		rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(
		.o_gen_clk	( gen_clk	),
		.i_nco_num	( 32'd5000	),
		.clk		( clk		),
		.rst_n		( rst_n		));


reg	[3:0]	cnt_common_node	;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

reg	[5:0]	o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_enb = 6'b111110;
		4'd1:	o_seg_enb = 6'b111101;
		4'd2:	o_seg_enb = 6'b111011;
		4'd3:	o_seg_enb = 6'b110111;
		4'd4:	o_seg_enb = 6'b101111;
		4'd5:	o_seg_enb = 6'b011111;
		default:o_seg_enb = 6'b111111;
	endcase
end

reg		o_seg_dp		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg_dp = i_six_dp[0];
		4'd1:	o_seg_dp = i_six_dp[1];
		4'd2:	o_seg_dp = i_six_dp[2];
		4'd3:	o_seg_dp = i_six_dp[3];
		4'd4:	o_seg_dp = i_six_dp[4];
		4'd5:	o_seg_dp = i_six_dp[5];
		default:o_seg_dp = 1'b0;
	endcase
end

reg	[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg = i_six_digit_seg[6:0];
		4'd1:	o_seg = i_six_digit_seg[13:7];
		4'd2:	o_seg = i_six_digit_seg[20:14];
		4'd3:	o_seg = i_six_digit_seg[27:21];
		4'd4:	o_seg = i_six_digit_seg[34:28];
		4'd5:	o_seg = i_six_digit_seg[41:35];
		default:o_seg = 7'b111_1110; // 0 display
	endcase
end

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		i_hms_cnt_start,
		i_hms_cnt_set,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		o_max_hit		;

input	[5:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

input	[7:0]	i_hms_cnt_start		;
input	[6:0]	i_hms_cnt_set		;

reg	[5:0]	o_hms_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= i_hms_cnt_start;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= i_hms_cnt_set;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end


wire		i_mode_7	;
assign	i_max_cnt_hr = (i_mode_7 == 1)? 4'd11 : 5'd23 ;

endmodule


module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
		o_mode,
		o_mode_7,
		o_position,
		o_alarm_en,
		o_sec_clk,
		o_min_clk,
		o_hr_clk,// hour
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hr_clk,// hour
		i_max_hit_sec,
		i_max_hit_min,
		i_max_hit_hr, // hour
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw7,
		clk,
		rst_n);

output	[1:0]	o_mode			;
output		o_mode_7		;
output	[1:0]	o_position		;
output		o_alarm_en		;
output		o_sec_clk		;
output		o_min_clk		;
output		o_hr_clk		; //hour

output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hr_clk		;// hour


input		i_max_hit_sec		;
input		i_max_hit_min		;
input		i_max_hit_hr		;// hour

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;
input  		i_sw7			;
input		clk			;
input		rst_n			;

parameter	MODE_CLOCK	= 2'b00	;
parameter	MODE_SETUP	= 2'b01	;
parameter	MODE_ALARM	= 2'b10	;

parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HR		= 2'b10	; //hour


wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));


wire		sw7			;
debounce	u4_debounce(
		.o_sw		( sw7		),
		.i_sw		( i_sw7		),
		.clk		( clk_100hz	));

reg	[1:0]	o_mode			;
always @(posedge sw0 or negedge rst_n) begin
  if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
	end else begin
		if(o_mode >= MODE_ALARM) begin
			o_mode <= MODE_CLOCK;
		end else begin
			o_mode <= o_mode + 1'b1;
		end
	end	  
end

reg	[1:0]	o_position		; // have to rewrite 
always @(posedge sw1 or negedge rst_n) begin
  if(rst_n == 1'b0) begin
		o_position <= POS_SEC;
	end else begin
		
		if(o_position >= POS_HR) begin
			o_position <= POS_SEC;
		end else begin
			o_position <= o_position + 1'b1;
		end
	end 
end 

reg		o_alarm_en		;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end

/*reg 	[5:0] o_hms_cnt;
reg	 [5:0] i_six_dp;
always @(posedge o_hms_cnt or negedge rst_n) begin
  if(rst_n == 1'b0) begin
      o_hms_cnt <= 6'd0;
      i_six_dp[0] <= 1'b0;
  end else begin
    if(o_hms_cnt >= 4'd11) begin
      o_hms_cnt <= 6'd0;
      i_six_dp[0] <= ~i_six_dp;
    end else begin
      o_hms_cnt <= o_hms_cnt + 1'b1;
    end
  end
end*/

reg		o_mode_7	;
always @(posedge sw7 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode_7 <= 1'b0	;
	end else begin
		o_mode_7 <= o_mode_7 + 1'b1;
	end
end

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_sec_clk		;
reg		o_min_clk		;
reg		o_hr_clk		;// hour
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg		o_alarm_hr_clk		;// hour
always @(*) begin
		case(o_mode)
			MODE_CLOCK : begin
				o_sec_clk = clk_1hz;
				o_min_clk = i_max_hit_sec;
				o_hr_clk = i_max_hit_min;
				o_alarm_sec_clk = 1'b0;
				o_alarm_min_clk = 1'b0;
				o_alarm_hr_clk = 1'b0;
			if(o_mode_7) begin
				o_sec_clk = clk_1hz;
				o_min_clk = i_max_hit_sec;
				o_hr_clk  = i_max_hit_min;
				o_alarm_sec_clk = 1'b0;
				o_alarm_min_clk = 1'b0;
				o_alarm_hr_clk = 1'b0;
			end
			end
			MODE_SETUP : begin
				case(o_position)
					POS_SEC : begin
						o_sec_clk = ~sw2;
						o_min_clk = 1'b0;
						o_hr_clk  = 1'b0;
						o_alarm_sec_clk = 1'b0;
						o_alarm_min_clk = 1'b0;
						o_alarm_hr_clk = 1'b0;
					end
					POS_MIN : begin
						o_sec_clk = 1'b0;
						o_min_clk = ~sw2;
						o_hr_clk  = 1'b0;
						o_alarm_sec_clk = 1'b0;
						o_alarm_min_clk = 1'b0;
						o_alarm_hr_clk = 1'b0;
					end
					POS_HR  : begin
						o_sec_clk = 1'b0;
						o_min_clk = 1'b0;
						o_hr_clk  = ~sw2; //hour
						o_alarm_sec_clk = 1'b0;
						o_alarm_min_clk = 1'b0;
						o_alarm_hr_clk = 1'b0;
						end
				endcase
			end
			MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hr_clk  = i_max_hit_min;
					o_alarm_sec_clk = ~sw2;
					o_alarm_min_clk = 1'b0;
 					o_alarm_hr_clk = 1'b0;
				end
				POS_MIN : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hr_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = ~sw2;
					o_alarm_hr_clk = 1'b0;
				end
				POS_HR : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_sec;
					o_hr_clk = i_max_hit_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hr_clk = ~sw2;
				end
			endcase
		end
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hr_clk = 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hr_clk = 1'b0;
		end
	endcase

/*end else begin
	case(o_mode_7)
		1'b1: begin	
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_sec;
			o_hr_clk  = i_max_hit_min;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hr_clk = 1'b0;
		end
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hr_clk = 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hr_clk = 1'b0;
		end
	endcase*/	
end
endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hrminsec(	
		o_sec,
		o_min,
		o_hr,
		o_max_hit_sec,
		o_max_hit_min,
		o_max_hit_hr,
		o_alarm,
		i_mode,
		i_mode_7,
		i_position,
		i_sec_clk,
		i_min_clk,
		i_hr_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hr_clk,
		i_alarm_en,
		clk,
		rst_n);

output	[5:0]	o_sec		;
output	[5:0]	o_min		;
output	[5:0]	o_hr		;
output		o_max_hit_sec	;
output		o_max_hit_min	;
output		o_max_hit_hr	;
output		o_alarm		;

input	[1:0]	i_mode		;
input		i_mode_7	;
input	[1:0]	i_position	;
input		i_sec_clk	;
input		i_min_clk	;
input		i_hr_clk	;
input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hr_clk	;
input		i_alarm_en	;

input		clk		;
input		rst_n		;

parameter	MODE_CLOCK	= 2'b00	;
parameter	MODE_SETUP	= 2'b01	;
parameter	MODE_ALARM	= 2'b10	;

parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HR		= 2'b10	;


/*reg	[4:0]	i_max_cnt_hr		;
reg	[4:0]	o_hms_cnt		;
always @(i_mode_7 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		i_max_cnt_hr <= 5'd23		;
		o_hr	 <= o_hr		;
	end else begin
		if( o_hms_cnt >= 4'd11 ) begin
		i_max_cnt_hr <= 4'd11		;
		o_hms_cnt<= o_hms_cnt;
		end else begin
		i_max_cnt_hr <= 4'd11		;
		o_hms_cnt<= o_hms_cnt - 4'd12;
		end
	end
end*/
//	MODE_CLOCK
wire	[5:0]	sec		;
wire		max_hit_sec	;
hms_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec			),
		.o_max_hit	( o_max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	min		;
wire		max_hit_min	;
hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min			),
		.o_max_hit	( o_max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	hr		;
wire		max_hit_hr	;
hms_cnt		u_hms_cnt_hr(
		.o_hms_cnt	( hr			),
		.o_max_hit	( o_max_hit_hr		),
		.i_hms_cnt_start( 1'b1			),
		.i_hms_cnt_set	( 1'b1			),
		.i_max_cnt	( i_max_cnt_hr		),
		.clk		( i_hr_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_sec	;
//	MODE_ALARM
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hr	;
hms_cnt		u_hms_cnt_alarm_hr(
		.o_hms_cnt	( alarm_hr		),
		.o_max_hit	( 			),
		.i_max_cnt	( 5'd23			),
		.clk		( i_alarm_hr_clk	),
		.rst_n		( rst_n			));
//MODE 12

reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
reg	[5:0]	o_hr		;
always @ (*) begin
	case(i_mode)
		MODE_CLOCK: 	begin
			o_sec	= sec;
			o_min	= min;
			o_hr	= hr;
		end
		MODE_SETUP:	begin
			o_sec	= sec;
			o_min	= min;
			o_hr	= hr;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec;
			o_min	= alarm_min;
			o_hr	= alarm_hr;
		end
	endcase
end
		
reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm <= 1'b0;
	end else begin
		if( (sec == alarm_sec) && (min == alarm_min) && (hr == alarm_hr) ) begin
			o_alarm <= 1'b1 & i_alarm_en;
		end else begin
			o_alarm <= o_alarm & i_alarm_en;
		end
	end
end

/*always @(posedge clk or negedge rst_n)begin
	if(rst_n == 1'b0) begin
		o_mode_7 <= 1'b0;
	end else begin
		if( o_mode_7 == 1'b1) begin*/
			
endmodule
//	--------------------------------------------------
//	BUZZ - Howl's moving castle
//	--------------------------------------------------
module	buzz(
		o_buzz,
		i_buzz_en,
		clk,
		rst_n);

output		o_buzz		;

input		i_buzz_en	;
input		clk		;
input		rst_n		;

parameter	C4 = 191113/8	;
parameter	D4 = 170262/8	;
parameter	E4 = 151686/8	;
parameter	F4 = 143173/8	;
parameter	G4 = 127553/8	;
parameter	A4 = 113636/8	;
parameter	B4 = 101238/8	;

parameter	C5 = 95556/8	;
parameter	D5 = 85131/8	;
parameter	E5 = 75843/8	;
parameter	F5 = 71586/8	;
parameter	F51= 67569/8	;
parameter	G5 = 63776/8	;
parameter	A5 = 56818/8	;
parameter	B5 = 50619/8	;


wire		clk_beat		;
nco	u_nco_beat(	
		.o_gen_clk	( clk_beat	),
		.i_nco_num	( 25000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[5:0]	cnt		;
always @ (posedge clk_beat or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 6'd0;
	end else begin
		if(cnt >= 6'd48) begin
			cnt <= 4'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[31:0]	nco_num		;

always @ (*) begin
	case(cnt)
		6'd00: nco_num = E4	;
		6'd01: nco_num = 1'b1	;
		6'd02: nco_num = 1'b1	;
		6'd03: nco_num = 1'b1	;
		6'd04: nco_num = 1'b1	;
		6'd05: nco_num = 1'b1	;
		6'd06: nco_num = D5	;
		6'd07: nco_num = C5	;
		6'd08: nco_num = B4	;
		6'd09: nco_num = C5	;
		6'd10: nco_num = C5	;
		6'd11: nco_num = C5	;
		6'd12: nco_num = A4	;
		6'd13: nco_num = C5	;
		6'd14: nco_num = E5	;
		6'd15: nco_num = A5	;
		6'd16: nco_num = A5	;
		6'd17: nco_num = A5	;
		6'd18: nco_num = A5	;
		6'd19: nco_num = G5	;
		6'd20: nco_num = F5	;
		6'd21: nco_num = G5	;
		6'd22: nco_num = G5	;
		6'd23: nco_num = G5	;
		6'd24: nco_num = B4	;
		6'd25: nco_num = E5	;
		6'd26: nco_num = G5	;
		6'd27: nco_num = B5	;
		6'd28: nco_num = B5	;
		6'd29: nco_num = A5	;
		6'd30: nco_num = G5	;
		6'd31: nco_num = F51	;
		6'd32: nco_num = G5	;
		6'd33: nco_num = A5	;
		6'd34: nco_num = A5	;
		6'd35: nco_num = G5	;
		6'd36: nco_num = F51	;
		6'd37: nco_num = F51	;
		6'd38: nco_num = E5	;
		6'd39: nco_num = D5	;
		6'd40: nco_num = C5	;
		6'd41: nco_num = D5	;
		6'd42: nco_num = E5	;
		6'd43: nco_num = D5	;
		6'd44: nco_num = A4	;
		6'd45: nco_num = B4	;
		6'd46: nco_num = B4	;
		6'd47: nco_num = B4	; 
		
	endcase
end

wire		buzz		;
nco	u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz = buzz & i_buzz_en;

endmodule

//-------------------------
//blink
//---------------------------
module blink(
    o_blink_seg_enb,
    o_mode,
    o_position,
    clk,
    rst_n);

parameter MODE_CLOCK  = 2'b00;
parameter MODE_SETUP  = 2'b01;
parameter MODE_ALARM  = 2'b10;
parameter POS_SEC     = 2'b00;
parameter POS_MIN     = 2'b01;
parameter POS_HR      = 2'b10;

output  [5:0] o_blink_seg_enb ;

input   [1:0] o_mode          ;
input   [1:0] o_position      ;
input         clk             ;
input         rst_n           ;

reg     [5:0] o_blink_seg_enb     ;    // OFF: o_blink_seg_enb = 0, ON: o_blink_seg_enb = 1

wire  clk_4hz;                    //about blink clk

nco		u_blink_nco(                 //make clk_4hz
		.o_gen_clk	( clk_4hz	),
		.i_nco_num	( 32'd12500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));
		
initial o_blink_seg_enb=6'b111111;
always@(posedge clk_4hz) begin
  case(o_mode)
 //   o_blink_seg_enb<=6'b111111;
    MODE_SETUP : begin
      o_blink_seg_enb<=6'b111111;   //all seg_enb on at first
      case(o_position)
        POS_SEC : begin
          if(1) begin
            o_blink_seg_enb[0]<=!o_blink_seg_enb[0];  
            o_blink_seg_enb[1]<=!o_blink_seg_enb[1];
          end
        end
        
        POS_MIN : begin
          if(1) begin
            o_blink_seg_enb[2]<=!o_blink_seg_enb[2];
            o_blink_seg_enb[3]<=!o_blink_seg_enb[3];
          end
        end
        
        POS_HR : begin
          if(1) begin
            o_blink_seg_enb[4]<=!o_blink_seg_enb[4];
            o_blink_seg_enb[5]<=!o_blink_seg_enb[5];
          end
        end
//        default : o_blink_seg_enb<=6'b111111;
      endcase
//      default : o_blink_seg_enb<=6'b111111;
    end
    MODE_CLOCK  : begin
      o_blink_seg_enb<=6'b111111; //clock mode: all seg_enb on at first
    end
    MODE_ALARM  : begin
      o_blink_seg_enb<=6'b111111; //alarm mode: all seg_enb on at first
    end
  endcase 
end

endmodule


module	top(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw7,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		i_sw7		;
input		clk		;
input		rst_n		;

wire	[1:0]	o_mode		;
wire		o_mode_7	;
wire	[1:0]	o_position	;
wire		i_max_hit_sec	;
wire		i_max_hit_min	;
wire		i_max_hit_hr	;
wire		o_alarm_en	;
wire		o_sec_clk	;
wire		o_min_clk	;
wire		o_hr_clk	;
wire		o_alarm_sec_clk	;
wire		o_alarm_min_clk	;
wire		o_alarm_hr_clk	;

controller	u_controller(
				.o_mode		(o_mode),
				.o_mode_7	(o_mode_7),
				.o_position	(o_position),
				.o_alarm_en	(o_alarm_en),
				.o_sec_clk	(o_sec_clk),
				.o_min_clk	(o_min_clk),
				.o_hr_clk	(o_hr_clk),
				.o_alarm_sec_clk(o_alarm_sec_clk),
				.o_alarm_min_clk(o_alarm_min_clk),
				.o_alarm_hr_clk	(o_alarm_hr_clk),
				.i_max_hit_sec	(i_max_hit_sec),
				.i_max_hit_min	(i_max_hit_min),
				.i_max_hit_hr	(i_max_hit_hr),
				.i_sw0	(i_sw0),
				.i_sw1	(i_sw1),
				.i_sw2	(i_sw2),
				.i_sw3	(i_sw3),
				.i_sw7	(i_sw7),
				.clk	(clk),
				.rst_n	(rst_n));
wire	[5:0]	o_min	;
wire	[5:0]	o_sec	;
wire	[5:0]	o_hr	;
wire		o_alarm_0 ;

hrminsec	u_hrminsec(	.o_sec		(o_sec),
				.o_min		(o_min),
				.o_hr		(o_hr),
				.o_max_hit_sec	(i_max_hit_sec),
				.o_max_hit_min	(i_max_hit_min),
				.o_max_hit_hr	(i_max_hit_hr),
				.o_alarm	(o_alarm_1),
				.i_mode		(o_mode),
				.i_mode_7	(o_mode_7),
				.i_position	(o_position),
				.i_sec_clk	(o_sec_clk),
				.i_min_clk	(o_min_clk),
				.i_hr_clk	(o_hr_clk),
				.i_alarm_sec_clk(o_alarm_sec_clk),
				.i_alarm_min_clk(o_alarm_min_clk),
				.i_alarm_hr_clk(o_alarm_hr_clk),
				.i_alarm_en	(o_alarm_en),
				.clk		(clk),
				.rst_n		(rst_n));


wire	[3:0]	o_left_0	;
wire	[3:0]	o_right_0	;
double_fig_sep	u0_dfs(
				.o_left		(o_left_0),
				.o_right	(o_right_0),
				.i_double_fig	(o_sec));
wire	[3:0]	o_left_1	;
wire	[3:0]	o_right_1	;
double_fig_sep	u1_dfs(
				.o_left		(o_left_1),
				.o_right	(o_right_1),
				.i_double_fig	(o_min));
wire	[3:0]	o_left_2	;
wire	[3:0]	o_right_2	;
double_fig_sep	u2_dfs(
				.o_left		(o_left_2),
				.o_right	(o_right_2),
				.i_double_fig	(o_hr));

wire	[6:0]	o_seg_0		;
wire	[6:0]	o_seg_1		;
wire	[6:0]	o_seg_2		;
wire	[6:0]	o_seg_3		;
wire	[6:0]	o_seg_4		;
wire	[6:0]	o_seg_5		;

wire [5:0] o_blink_seg_enb;

fnd_dec		u0_fnd_dec(
				.o_seg(o_seg_0),
				.i_blink_seg(o_blink_seg_enb[0]),
				.i_num(o_left_0));
				
fnd_dec		u1_fnd_dec(
				.o_seg(o_seg_1),
				.i_blink_seg(o_blink_seg_enb[1]),
				.i_num(o_right_0));

fnd_dec		u2_fnd_dec(
				.o_seg(o_seg_2),
				.i_blink_seg(o_blink_seg_enb[2]),
				.i_num(o_left_1));

fnd_dec		u3_fnd_dec(
				.o_seg(o_seg_3),
				.i_blink_seg(o_blink_seg_enb[3]),
				.i_num(o_right_1));

fnd_dec		u4_fnd_dec(
				.o_seg(o_seg_4),
				.i_blink_seg(o_blink_seg_enb[4]),
				.i_num(o_left_2));

fnd_dec		u5_fnd_dec(
				.o_seg(o_seg_5),
				.i_blink_seg(o_blink_seg_enb[5]),
				.i_num(o_right_2));

wire	[41:0]	six_digit_seg	;
assign six_digit_seg = { o_seg_4, o_seg_5, o_seg_2, o_seg_3, o_seg_0, o_seg_1 };

led_disp	u_led_disp(
				.o_seg		(o_seg),
				.o_seg_dp	(o_seg_dp),
				.o_seg_enb	(o_seg_enb),
				.i_six_digit_seg(six_digit_seg),
				.i_six_dp	(i_six_dp),
				.clk		(clk),
				.rst_n		(rst_n));
buzz		u_buzz(
				.o_buzz		(o_alarm),
				.i_buzz_en	(o_alarm_1),
				.clk		(clk),
				.rst_n		(rst_n));

	
//wire  [5:0] o_blink_seg_enb; 
   
blink u_blink(
    .o_blink_seg_enb  (o_blink_seg_enb),
    .o_mode           (o_mode),
    .o_position       (o_position),
    .clk              (clk),
    .rst_n            (rst_n));


endmodule
