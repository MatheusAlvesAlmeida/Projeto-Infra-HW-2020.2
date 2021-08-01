module mux_ULA_PC (
  input  wire [1:0]  PCSource,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  input  wire [31:0] input_3,
  input  wire [31:0] input_4,

  output wire [31:0] result
);

  wire [31:0] aux_1;
  wire [31:0] aux_2;

  assign aux_1  = PCSource[0] ? input_2 : input_1;
  assign aux_2  = PCSource[0] ? input_4 : input_3;
  
  assign result = PCSource[1] ? aux_2 : aux_1;

endmodule