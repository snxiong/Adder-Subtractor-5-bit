// Steven Xiong
// CSC 137 Assignment#4
// Adder/Subtractor 5-bit
module inputModule;
	parameter STDIN = 32'h8000_0000;
	
	reg [7:0] str [1:4];
	reg [7:0] operator [1:4];
	reg [4:0] X, Y;
	output [4:0] S;
	output E;
	output [5:0] C;
	reg [7:0] newline;
	reg addORsub;
	reg newNum;
	
	BigAdderMod my_bigAdder(X,Y,S,C,E,addORsub);

	initial begin
		$display("Enter X (range 00 ~ 15): ");
		str[1] = $fgetc(STDIN);
		str[2] = $fgetc(STDIN);
		
		str[1] = str[1] - 48;
		str[1] = str[1] * 10;
		str[2] = str[2] - 48;
		str[2] = str[2] + str[1];
		X = str[2];
		newline = $fgetc(STDIN);

		$display("Enter Y (range 00 ~ 15); ");
		str[3] = $fgetc(STDIN);
		str[4] = $fgetc(STDIN);
		str[3] = str[3] - 48;
		str[3] = str[3] * 10;
		str[4] = str[4] - 48;
		str[4] = str[4] + str[3];
		Y = str[4];
		newline = $fgetc(STDIN);

		$display("Enter either '+' or '-': ");
		operator[1] = $fgetc(STDIN);
		if(operator[1] == 43)
			addORsub = 0;
		else if(operator[1] == 45)
			addORsub = 1;				

		#1
		$display("X = %b (%d) Y = %b (%d) C0 = %d ", X, X, Y, Y, C[0]);
		$display("Results = %b (as unsigned %d)", S, S);
		$display("C4 = %d C5 = %d E = %d", C[4], C[5], E);
		if(E == 0)
			$display("Since E is %d, C5 is not needed.", E);
		else if(E == 1)
			$display("Since E is %d, correct with C5 in front: 0%b",E, S);
	end


endmodule

module MajorityMod(x, y, cin, cout);
	input x, y, cin;
	output cout;
	wire and0, and1, and2;

	and(and0, x, y);
	and(and1, x, cin);
	and(and2, cin, y);
	
	or(cout, and0, and1, and2);
endmodule

module ParityMod(x, y, cin, sum);
	input x, y, cin;
	output sum;

	wire wireXor;
	
	xor(wireXor, x, y);
	xor(sum, wireXor, cin);
endmodule

module FullAdderMod(x, y, cin, cout, sum);
	input x, y, cin;
	output cout, sum;

	ParityMod my_parity(x, y, cin, sum);
	MajorityMod my_majority(x, y, cin, cout);

endmodule

module BigAdderMod(X, Y, S, C, E, addORsub);
	input [4:0] X, Y;
	input addORsub;
	output [4:0] S;
	output [5:0] C;
	output E;


	or(C[0], addORsub,0); 

	wire [4:0] xorWire;
	xor(xorWire[0], C[0], Y[0]);
	xor(xorWire[1], C[0], Y[1]);
	xor(xorWire[2], C[0], Y[2]);
	xor(xorWire[3], C[0], Y[3]);
	xor(xorWire[4], C[0], Y[4]);

	FullAdderMod my_fullAdder0(X[0], xorWire[0], C[0], C[1], S[0]);
	FullAdderMod my_fullAdder1(X[1], xorWire[1], C[1], C[2], S[1]);
	FullAdderMod my_fullAdder2(X[2], xorWire[2], C[2], C[3], S[2]);
	FullAdderMod my_fullAdder3(X[3], xorWire[3], C[3], C[4], S[3]);
	FullAdderMod my_fullAdder4(X[4], xorWire[4], C[4], C[5], S[4]);

	xor(E, C[5], C[4]);
endmodule


