module  tb_prj02;
//------------------------------
//instances
//------------------------------
reg	a;
reg	b;
reg	ci;

wire	s1;
wire	co1;

wire	s2;
wire	co2;

wire	s3;
wire	co3;

fa_dataflow dut_1( .s (s1),
		   .co (co1),
		   .a (a),
		   .b (b),
		   .ci (ci));

fa_behavior dut_2( .s (s2),
		   .co (co2),
		   .a (a),
		   .b (b),
		   .ci (ci));

fa_case dut_3( .s (s3),
		   .co (co3),
		   .a (a),
		   .b (b),
		   .ci (ci));

//------------------------------
//stimulus
//------------------------------
initial begin
	$display("Dataflow Level:  s1, co1");
	$display("Behavioral Level:  s2, co2");
	$display("Using 'case':  s3, co3");
	$display("===========================================================================");
	$display(" 	ci	a	b	s1	co1	s2	co2	s3	co3");
	$display("===========================================================================");
	#(50)	{ci, a, b} = 3'b_000;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_001;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_010;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_011;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_100;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_101;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_110;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	{ci, a, b} = 3'b_111;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", ci, a, b ,s1, co1, s2, co2, s3, co3);
	#(50)	$finish;
end

endmodule