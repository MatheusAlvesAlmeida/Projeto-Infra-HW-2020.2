module mux_SHIFT_AMT (
  input  wire [1:0]  ShiftAmt,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  input  wire [31:0] input_3,

  output wire [4:0] result,
);

  wire [31:0] aux_1;
  wire [31:0] aux_2;
  wire [31:0] aux_3;

  assign aux_1  = ShiftAmt[0] ? input_2 : input_1;
  assign aux_2  = ShiftAmt[0] ? 32'b00000000000000000000000000010000 : input_3;
  assign aux_3  = ShiftAmt[1] ? aux_2 : aux_1;
  
  assign result = aux_3[4:0];

endmodule 