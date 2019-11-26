module	tb_prj03;

reg	in0;
reg	in1;
reg	sel;

wire	out1;

wire	out2;

wire	out3;

mux2to1_cond	dut_1(   .out( out1	),
		    	 .in0( in0	),
		   	 .in1( in1	),
		    	 .sel( sel	));

mux2to1_if	dut_2(	 .out( out2	),
		    	 .in0( in0	),
		   	 .in1( in1	),
		    	 .sel( sel	));

mux2to1_case	dut_3(	 .out( out3	),
		    	 .in0( in0	),
		   	 .in1( in1	),
		    	 .sel( sel	));

initial begin
	$display("Conditional Expression: out1");
	$display("Using 'if': out2");
	$display("Using 'case': out3");
	$display("=======================================================");
	$display("	in0	in1	sel	out1	out2	out3	");
	$display("=======================================================");
	#(50)	{in0, in1, sel} = 3'b000;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b001;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b010;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b011;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b100;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b101;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b110;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	{in0, in1, sel} = 3'b111;	#(50)	$display("	%b\t%b\t%b\t%b\t%b\t%b", in0, in1, sel, out1, out2, out3);
	#(50)	$finish;
end

endmodule