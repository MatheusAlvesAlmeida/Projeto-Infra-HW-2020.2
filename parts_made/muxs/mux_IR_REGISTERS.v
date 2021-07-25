module mux_IR_REGISTERS (
  input  wire        RegDst,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  
  output wire [31:0] result,
);

  assign result = RegDst ? input_2 : input_1;

endmodule 