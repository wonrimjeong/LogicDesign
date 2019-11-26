module nonblock(	q,
			d,
			clk);

output	q;
input	d;
input	clk;

reg	n1;
reg	q;

always @(posedge clk) begin 
n1 <= d;  // nonblocking 
q  <= n1; // nonblocking 
end

endmodule

module block(		q,
			d,
			clk);

output	q;
input	d;
input	clk;

reg	n1;
reg	q;

always @(posedge clk) begin 
n1 = d;  // blocking 
q  = n1; // blocking 
end

endmodule 