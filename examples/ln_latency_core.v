// 36-cycle ln_latency_core

`define ONE_HALF 32'h3f000000
`define ONE_THIRD 32'h3eaaaaab
`define ONE_FOURTH 32'h3e800000
`define ONE_FIFTH 32'h3e4ccccd
`define ONE 32'h3f800000

module ln_latency_core(input  clk, input  rst_n, input [31:0] x, input  start, output [31:0] ln, output  done, output  error);

wire [31:0] ln_36;
wire [31:0] s12_17;
reg [31:0] s12_18, s12_19, s12_20, s12_21, s12_22;
wire [31:0] e4_10;
wire [31:0] t5_20;
reg [31:0] t5_21, t5_22, t5_23, t5_24, t5_25, t5_26, t5_27, t5_28, t5_29;
wire [31:0] t2_10;
wire [31:0] t3_15;
wire [31:0] s34_22;
wire  start_0;
wire  done_0;
reg  done_1, done_2, done_3, done_4, done_5, done_6, done_7, done_8, done_9, done_10, done_11, done_12, done_13, done_14, done_15, done_16, done_17, done_18, done_19, done_20, done_21, done_22, done_23, done_24, done_25, done_26, done_27, done_28, done_29, done_30, done_31, done_32, done_33, done_34, done_35, done_36;
wire [31:0] s1234_29;
wire  error_0;
reg  error_1, error_2, error_3, error_4, error_5, error_6, error_7, error_8, error_9, error_10, error_11, error_12, error_13, error_14, error_15, error_16, error_17, error_18, error_19, error_20, error_21, error_22, error_23, error_24, error_25, error_26, error_27, error_28, error_29, error_30, error_31, error_32, error_33, error_34, error_35, error_36;
wire [31:0] e5_15;
wire [31:0] x_0;
reg [31:0] x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10;
wire [31:0] x_abs_0;
wire [31:0] t4_15;
wire [31:0] e3_10;
wire [31:0] e2_5;

assign x_0 = x;
assign start_0 = start;
assign ln = ln_36;
assign done = done_36;
assign error = error_36;

assign done_0 = start_0;
assign x_abs_0 = {1'b0, x_0[30:0]};
assign error_0 = x_abs_0 > `ONE;
mult5 u3(clk, x_0, x_0, e2_5);
mult5 u4(clk, e2_5, `ONE_HALF, t2_10);
mult5 u5(clk, e2_5, x_5, e3_10);
mult5 u6(clk, e2_5, e2_5, e4_10);
sub7 u7(clk, x_10, t2_10, s12_17);
mult5 u8(clk, e4_10, x_10, e5_15);
mult5 u9(clk, e3_10, `ONE_THIRD, t3_15);
mult5 u10(clk, e4_10, `ONE_FOURTH, t4_15);
sub7 u11(clk, t3_15, t4_15, s34_22);
mult5 u12(clk, e5_15, `ONE_FIFTH, t5_20);
add7 u13(clk, s12_22, s34_22, s1234_29);
add7 u14(clk, s1234_29, t5_29, ln_36);

always @(posedge clk) begin
	if (~rst_n) begin
		s12_18 <= 0; s12_19 <= 0; s12_20 <= 0; s12_21 <= 0; s12_22 <= 0;
		t5_21 <= 0; t5_22 <= 0; t5_23 <= 0; t5_24 <= 0; t5_25 <= 0; t5_26 <= 0; t5_27 <= 0; t5_28 <= 0; t5_29 <= 0;
		done_1 <= 0; done_2 <= 0; done_3 <= 0; done_4 <= 0; done_5 <= 0; done_6 <= 0; done_7 <= 0; done_8 <= 0; done_9 <= 0; done_10 <= 0; done_11 <= 0; done_12 <= 0; done_13 <= 0; done_14 <= 0; done_15 <= 0; done_16 <= 0; done_17 <= 0; done_18 <= 0; done_19 <= 0; done_20 <= 0; done_21 <= 0; done_22 <= 0; done_23 <= 0; done_24 <= 0; done_25 <= 0; done_26 <= 0; done_27 <= 0; done_28 <= 0; done_29 <= 0; done_30 <= 0; done_31 <= 0; done_32 <= 0; done_33 <= 0; done_34 <= 0; done_35 <= 0; done_36 <= 0;
		error_1 <= 0; error_2 <= 0; error_3 <= 0; error_4 <= 0; error_5 <= 0; error_6 <= 0; error_7 <= 0; error_8 <= 0; error_9 <= 0; error_10 <= 0; error_11 <= 0; error_12 <= 0; error_13 <= 0; error_14 <= 0; error_15 <= 0; error_16 <= 0; error_17 <= 0; error_18 <= 0; error_19 <= 0; error_20 <= 0; error_21 <= 0; error_22 <= 0; error_23 <= 0; error_24 <= 0; error_25 <= 0; error_26 <= 0; error_27 <= 0; error_28 <= 0; error_29 <= 0; error_30 <= 0; error_31 <= 0; error_32 <= 0; error_33 <= 0; error_34 <= 0; error_35 <= 0; error_36 <= 0;
		x_1 <= 0; x_2 <= 0; x_3 <= 0; x_4 <= 0; x_5 <= 0; x_6 <= 0; x_7 <= 0; x_8 <= 0; x_9 <= 0; x_10 <= 0;
	end else begin
		s12_18 <= s12_17; s12_19 <= s12_18; s12_20 <= s12_19; s12_21 <= s12_20; s12_22 <= s12_21;
		t5_21 <= t5_20; t5_22 <= t5_21; t5_23 <= t5_22; t5_24 <= t5_23; t5_25 <= t5_24; t5_26 <= t5_25; t5_27 <= t5_26; t5_28 <= t5_27; t5_29 <= t5_28;
		done_1 <= done_0; done_2 <= done_1; done_3 <= done_2; done_4 <= done_3; done_5 <= done_4; done_6 <= done_5; done_7 <= done_6; done_8 <= done_7; done_9 <= done_8; done_10 <= done_9; done_11 <= done_10; done_12 <= done_11; done_13 <= done_12; done_14 <= done_13; done_15 <= done_14; done_16 <= done_15; done_17 <= done_16; done_18 <= done_17; done_19 <= done_18; done_20 <= done_19; done_21 <= done_20; done_22 <= done_21; done_23 <= done_22; done_24 <= done_23; done_25 <= done_24; done_26 <= done_25; done_27 <= done_26; done_28 <= done_27; done_29 <= done_28; done_30 <= done_29; done_31 <= done_30; done_32 <= done_31; done_33 <= done_32; done_34 <= done_33; done_35 <= done_34; done_36 <= done_35;
		error_1 <= error_0; error_2 <= error_1; error_3 <= error_2; error_4 <= error_3; error_5 <= error_4; error_6 <= error_5; error_7 <= error_6; error_8 <= error_7; error_9 <= error_8; error_10 <= error_9; error_11 <= error_10; error_12 <= error_11; error_13 <= error_12; error_14 <= error_13; error_15 <= error_14; error_16 <= error_15; error_17 <= error_16; error_18 <= error_17; error_19 <= error_18; error_20 <= error_19; error_21 <= error_20; error_22 <= error_21; error_23 <= error_22; error_24 <= error_23; error_25 <= error_24; error_26 <= error_25; error_27 <= error_26; error_28 <= error_27; error_29 <= error_28; error_30 <= error_29; error_31 <= error_30; error_32 <= error_31; error_33 <= error_32; error_34 <= error_33; error_35 <= error_34; error_36 <= error_35;
		x_1 <= x_0; x_2 <= x_1; x_3 <= x_2; x_4 <= x_3; x_5 <= x_4; x_6 <= x_5; x_7 <= x_6; x_8 <= x_7; x_9 <= x_8; x_10 <= x_9;
	end
end

endmodule

