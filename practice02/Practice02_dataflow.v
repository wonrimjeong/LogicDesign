module fa_dataflow(	s,
			co,
			a,
			b,
			ci	);

output	s;	//sum
output	co;	//carry out

input	a;	//input a
input	b;	//input b
input	ci;	//carry in

assign	s=(~a&~b&ci)|(~a&b&~ci)|(a&b&ci)|(a&~b&~ci);
assign	co=(a&b)|(b&ci)|(a&ci);

endmodule
