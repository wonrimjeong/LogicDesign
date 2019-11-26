module fa_case(		s,
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
	case(	{ci, a, b}	)
		3'b000 : {co, s} = 2'b00;
		3'b001 : {co, s} = 2'b01;
		3'b010 : {co, s} = 2'b01;
		3'b011 : {co, s} = 2'b10;
		3'b100 : {co, s} = 2'b01;
		3'b101 : {co, s} = 2'b10;
		3'b110 : {co, s} = 2'b10;
		3'b111 : {co, s} = 2'b11;
	endcase
end
endmodule