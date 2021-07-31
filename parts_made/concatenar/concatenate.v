module concatenate(
  input wire        DoConcatenate,
  input wire [27:0] data_in_1,
  input wire [31:0] data_in_2,

  input wire [31:0] data_out
);

  wire [3:0] aux;
  assign aux = [3:0] data_in_2;

  assign data_out = {data_in_1, aux};

endmodule