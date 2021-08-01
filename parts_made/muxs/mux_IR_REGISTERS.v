module mux_IR_REGISTERS (
  input  wire [2:0]  RegDst,
  input  wire [4:0] input_1,
  input  wire [4:0] input_2,
  
  output wire [4:0] result
);

  wire [4:0] aux_1;
  wire [4:0] aux_2;
  wire [4:0] aux_3;

  assign aux_1  = RegDst[0] ? input_2 : input_1;
  assign aux_2  = RegDst[0] ? 32'b11110 : 32'b11101;
  assign aux_3  = RegDst[1] ? aux_2 : aux_1;

  assign result = RegDst[2] ? 32'b11111 : aux_3;

endmodule 
