module mux_IR_REGISTERS (
  input  wire [2:0]  RegDst,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  
  output wire [31:0] result
);

  wire [31:0] aux_1;
  wire [31:0] aux_2;

  assign aux_1 = RegDst[0] ? input_2 : input_1;
  assign aux_2 = RegDst[0] ? 32'b00000000000000000000000000011110 : 32'b0000000000000000000000000011111;

  assign result = RegDst[1] ? aux_2 : aux_1;

endmodule 
