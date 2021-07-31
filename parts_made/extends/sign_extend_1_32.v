module sign_extend_1_32 (
  input  wire        data_in,
  output wire [31:0] data_out
);

  assign data_out = {31'b0000000000000000000000000000000 , data_in};

endmodule