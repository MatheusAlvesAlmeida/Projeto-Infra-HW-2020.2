module mux_SHIFT_SRC (
  input  wire [1:0]  ShiftSrc,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  input  wire [31:0] input_3,

  output wire [31:0] result,
);

  wire [31:0] aux;

  assign aux    = ShiftSrc[0] ? input_2 : input_1;
  assign result = ShiftSrc[1] ? input_3 : aux;

endmodule 