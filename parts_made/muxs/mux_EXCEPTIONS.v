module mux_EXCEPTIONS (
  input  wire [1:0]  Exception,
  output wire [31:0] result,
);

  wire [31:0] aux;

  assign aux    = Exception[0] ? 32'b00000000000000000000000011111110 : 32'b00000000000000000000000011111101;
  assign result = Exception[1] ? 32'b00000000000000000000000011111111 : aux;

endmodule 