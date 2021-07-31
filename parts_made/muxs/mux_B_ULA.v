module mux_B_ULA (
  input  wire [2:0]  ALUSrcB,
  input  wire [31:0] input_1,
  input  wire [31:0] input_3,
  input  wire [31:0] input_4,
  input  wire [31:0] input_5,

  output wire [31:0] result
);

  wire [31:0] aux_1;
  wire [31:0] aux_2;
  wire [31:0] aux_3;

  assign aux_1  = ALUSrcB[0] ? 32'b00000000000000000000000000000100 : input_1;
  assign aux_2  = ALUSrcB[0] ? input_4 : input_3;
  assign aux_3  = ALUSrcB[1] ? aux_2   : aux_1;
  
  assign result = ALUSrcB[2] ? input_5 : aux_3;

endmodule 