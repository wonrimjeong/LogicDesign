module tb_bnb;

parameter tCK = 1000/50 ; 
wire	q_block;
wire	q_nonblock;

reg	d;
reg	clk;


block		dut0(	.q(q_block),
			.d(d),
			.clk(clk));

nonblock	dut1(	.q(q_nonblock),
			.d(d),
			.clk(clk));
initial clk = 1'b0; 
always #(tCK/2) clk = ~clk;


initial begin
$display("===========================================");
$display("	d	q0	q1	");
$display("===========================================");
#(50)	{d}=1'b0;	$display("	%b\t%b\t%b", d, q_block, q_nonblock);
#(50)	{d}=1'b1;	$display("	%b\t%b\t%b", d, q_block, q_nonblock);
#(50)	{d}=1'b1;	$display("	%b\t%b\t%b", d, q_block, q_nonblock);
#(50)	{d}=1'b0;	$display("	%b\t%b\t%b", d, q_block, q_nonblock);
#(50)	{d}=1'b0;	$display("	%b\t%b\t%b", d, q_block, q_nonblock);
$finish;
end
endmodule 