module shift_left_2_down (
  input  wire [31:0] data_in,
  output wire [31:0] data_out,
);

  wire [27:0] aux;

  assign aux      = data_in[31:4];
  assign data_out = {aux << 2};

endmodule