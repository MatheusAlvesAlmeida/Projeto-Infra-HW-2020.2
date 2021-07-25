module mux_A_ULA (
  input  wire [1:0]  ALUSrcA;
  input  wire [31:0] input_1;
  input  wire [31:0] input_2;
  input  wire [31:0] input_3;

  output wire [31:0] result;
);

  wire [31:0] aux;

  assign aux    = ALUSrcA[0] ? input_2 : input_1;
  assign result = ALUSrcA[1] ? input_3 : aux;

endmodule 