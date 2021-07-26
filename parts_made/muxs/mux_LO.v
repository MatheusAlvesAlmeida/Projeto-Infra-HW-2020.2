module mux_LO (
  input  wire        MultOrDiv,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  
  output wire [31:0] result,
);

  assign result = MultOrDiv ? input_2 : input_1;

endmodule 