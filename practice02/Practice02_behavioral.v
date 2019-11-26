module fa_behavior(	s,
			co,
			a,
			b,
			ci	);

output	s;	//sum
output	co;	//carry out

input	a;	//input a
input	b;	//input b
input	ci;	//carry in

reg	s;
reg	co;

always @(ci, a, b) begin
	s=(~a&~b&ci)|(~a&b&~ci)|(a&b&ci)|(a&~b&~ci);
	co=(a&b)|(b&ci)|(a&ci);
end

endmodule
