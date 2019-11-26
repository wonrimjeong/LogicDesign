module tb;

wire	q_latch;
wire	q_dff_asyn;
wire	q_dff_syn;

reg	d;
reg	clk;
reg	rst_n;

initial	clk=1'b0;
always	#(100) clk = ~clk;

d_latch		dut0(	.q	(q_latch),
			.d	(d	),
			.clk	(clk	),
			.rst_n	(rst_n	));

dff_asyn 	dut1(	.q	(q_dff_asyn),
			.d	(d	),
			.clk	(clk	),
			.rst_n	(rst_n	));

dff_syn		dut2(	.q	(q_dff_syn),
			.d	(d	),
			.clk	(clk	),
			.rst_n	(rst_n	));

initial begin
$display("===========================================");
$display("	rst_n	d	q0	q1	q2");
$display("===========================================");
#(0)	{rst_n, d} = 2'b00;
#(50)	{rst_n, d} = 2'b00; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b10; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b10; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b11; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b10; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b01; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
#(50)	{rst_n, d} = 2'b11; #(50)	$display("	%b\t%b\t%b\t%b\t%b", rst_n, d, q_latch, q_dff_asyn, q_dff_syn);
$finish;
end

endmodule
