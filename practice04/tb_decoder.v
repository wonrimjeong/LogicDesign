module	tb_decoder;

wire	[7:0]	out_dec3to8_shift;
wire	[7:0]	out_dec3to8_case;

reg	[2:0]	in;
reg	en;

dec3to8_shift	dut0(	.out	(out_dec3to8_shift),
			.in	(in),
			.en	(en));
dec3to8_case	dut1(	.out	(out_dec3to8_case),
			.in	(in),
			.en	(en));

initial begin
$display("=====================================");
$display("	en	in	out0	out1");
$display("=====================================");
#(50)	{en, in} = 4'b0001; #(50)	$display("	%b\t%b\t%b\t%b", en, in, out_dec3to8_shift, out_dec3to8_case);
#(50)	{en, in} = 4'b0101; #(50)	$display("	%b\t%b\t%b\t%b", en, in, out_dec3to8_shift, out_dec3to8_case);
#(50)	{en, in} = 4'b1011; #(50)	$display("	%b\t%b\t%b\t%b", en, in, out_dec3to8_shift, out_dec3to8_case);
#(50)	{en, in} = 4'b1001; #(50)	$display("	%b\t%b\t%b\t%b", en, in, out_dec3to8_shift, out_dec3to8_case);
$finish;
end

endmodule


