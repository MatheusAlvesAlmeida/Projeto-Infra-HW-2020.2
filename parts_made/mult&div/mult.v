module mult (
    input  wire          clock,
    input  wire          reset,
    input  wire          MultOrDiv,
    input  signed [31:0] A,
    input  signed [31:0] B,
    output reg    [31:0] hi, 
    output reg    [31:0] lo
);

reg [63:0] add;
reg [63:0] sub;
reg [63:0] prod;
integer i;

always @(posedge clock) begin
    if(reset == 1'b1) begin
        hi     = 32'b0;
        lo     = 32'b0;
        add    = 64'b0;
        sub    = 64'b0;
        prod   = 64'b0;
    end
    else if (MultOrDiv == 0) begin
        add  = {A, 33'b0, 1'b0};
        sub  = {(~A + 1), 33'b0, 1'b0};
        prod = {32'b0, B, 1'b0};
    end
    for (i = 0; i < 32; i = i + 1) begin
        if(prod[62] == 0 && prod[63] == 1) begin
            prod = prod + add;
        end
        else if(prod[62] == 1 && prod[63] == 0) begin
            prod = prod + sub;
        end
        prod = prod >> 1;
    end
    hi = prod[64:33];
    lo = prod[32:1]; 
end

endmodule