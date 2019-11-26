module	tb_prf03_4to1;

reg	in0;
reg	in1;
reg	in2;
reg	in3;
reg	[1:0] sel;

wire	out1;
wire	out2;
wire	out3;

mux4to1_inst	dut_1(	.out	(out1),
			.in0	(in0),
			.in1	(in1),
			.in2	(in2),
			.in3	(in3),
			.sel	(sel));

mux4to1_if	dut_2(	.out	(out2),
			.in0	(in0),
			.in1	(in1),
			.in2	(in2),
			.in3	(in3),
			.sel	(sel));

mux4to1_case	dut_3(	.out	(out3),
			.in0	(in0),
			.in1	(in1),
			.in2	(in2),
			.in3	(in3),
			.sel	(sel));

initial begin
	$display("Using 'inst':	out1");
	$display("Using 'if':	out2");
	$display("Using 'case':	out3");
	$display("===================================================================");
	$display("	in0	in1	in2	in3	sel	out1	out2	out3");
	$display("===================================================================");
	#(50)	{in0, in1, in2, in3, sel} = 5'b00000;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel, out1, out2, out3);
	#(50)	{in0, in1, in2, in3, sel} = 5'b00101;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel, out1, out2, out3);
	#(50)	{in0, in1, in2, in3, sel} = 5'b01010;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel, out1, out2, out3);
	#(50)	{in0, in1, in2, in3, sel} = 5'b10110;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel, out1, out2, out3);
	#(50)	{in0, in1, in2, in3, sel} = 5'b11110;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel, out1, out2, out3);
	#(50)	$finish;
end

endmodule