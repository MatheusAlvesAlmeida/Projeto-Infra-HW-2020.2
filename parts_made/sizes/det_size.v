module det_size (
  input  wire [1:0] DetSizeCtrl,
  input  wire [31:0] data_in,
  output wire [31:0] data_out
);

  wire [31:0] aux;
  assign aux = DetSizeCtrl[0] ? {{24{1'b0}}, data_in[7:0]} : data_in;
  assign data_out = DetSizeCtrl[1] ? {{16{1'b0}}, data_in[15:0]} : aux;

endmodule