module mux_MEMORY_REGISTERS (
  input  wire [2:0]  MemToReg,
  input  wire [31:0] input_1,
  input  wire [31:0] input_2,
  input  wire [31:0] input_3,
  input  wire [31:0] input_4,
  input  wire [31:0] input_5,
  input  wire [31:0] input_6,
  input  wire [31:0] input_7,

  output wire [31:0] result
);

  wire [31:0] aux_1;
  wire [31:0] aux_2;
  wire [31:0] aux_3;
  wire [31:0] aux_4;
  wire [31:0] aux_5;

  assign aux_1  = MemToReg[0] ? input_2 : input_1;
  assign aux_2  = MemToReg[0] ? input_4 : input_3;
  assign aux_3  = MemToReg[0] ? input_6 : input_5;

  assign aux_4  = MemToReg[1] ? aux_2   : aux_1;
  assign aux_5  = MemToReg[1] ? input_7 : aux_3;

  assign result = MemToReg[2] ? aux_5   : aux_4;

endmodule 