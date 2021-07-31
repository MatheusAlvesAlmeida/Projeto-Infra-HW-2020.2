module mux_PC_MEMORY (
  input  wire [1:0]  IorD,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  input  wire [31:0] input_3,

  output wire [31:0] result
);

  wire [31:0] aux;

  assign aux    = IorD[0] ? input_2 : input_1;
  assign result = IorD[1] ? input_3 : aux;

endmodule 