`define one_half 32'h3f000000
`define one_fifth 32'h3e4ccccd
`define one_fourth 32'h3e800000
`define one_third 32'h3eaaaaab

module wat(input  clk, output [31:0] ln, input [31:0] x);

wire [31:0] ln_63;
wire  s12_35;
reg  s12_36, s12_37, s12_38, s12_39, s12_40, s12_41, s12_42, s12_43, s12_44, s12_45, s12_46, s12_47, s12_48, s12_49;
wire  t4_42;
wire  t5_56;
wire  t2_28;
wire  t3_42;
wire  s34_49;
wire  s1234_56;
wire  e4_28;
wire  e5_42;
wire [31:0] x_0;
reg [31:0] x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15, x_16, x_17, x_18, x_19, x_20, x_21, x_22, x_23, x_24, x_25, x_26, x_27, x_28;
wire  e3_28;
wire  e2_14;

assign x_0 = x;
assign ln = ln_63;

mult u0(clk, x_0, x_0, e2_14);
mult u1(clk, e2_14, one_half, t2_28);
mult u2(clk, e2_14, x_14, e3_28);
mult u3(clk, e2_14, e2_14, e4_28);
sub u4(clk, x_28, t2_28, s12_35);
mult u5(clk, e4_28, x_28, e5_42);
mult u6(clk, e3_28, one_third, t3_42);
mult u7(clk, e4_28, one_fourth, t4_42);
sub u8(clk, t3_42, t4_42, s34_49);
mult u9(clk, e5_42, one_fifth, t5_56);
add u10(clk, s12_49, s34_49, s1234_56);
add u11(clk, s1234_56, t5_56, ln_63);

always @(posedge clk) begin
	s12_36 <= s12_35;
	s12_37 <= s12_36;
	s12_38 <= s12_37;
	s12_39 <= s12_38;
	s12_40 <= s12_39;
	s12_41 <= s12_40;
	s12_42 <= s12_41;
	s12_43 <= s12_42;
	s12_44 <= s12_43;
	s12_45 <= s12_44;
	s12_46 <= s12_45;
	s12_47 <= s12_46;
	s12_48 <= s12_47;
	s12_49 <= s12_48;
	x_1 <= x_0;
	x_2 <= x_1;
	x_3 <= x_2;
	x_4 <= x_3;
	x_5 <= x_4;
	x_6 <= x_5;
	x_7 <= x_6;
	x_8 <= x_7;
	x_9 <= x_8;
	x_10 <= x_9;
	x_11 <= x_10;
	x_12 <= x_11;
	x_13 <= x_12;
	x_14 <= x_13;
	x_15 <= x_14;
	x_16 <= x_15;
	x_17 <= x_16;
	x_18 <= x_17;
	x_19 <= x_18;
	x_20 <= x_19;
	x_21 <= x_20;
	x_22 <= x_21;
	x_23 <= x_22;
	x_24 <= x_23;
	x_25 <= x_24;
	x_26 <= x_25;
	x_27 <= x_26;
	x_28 <= x_27;
end

endmodule

