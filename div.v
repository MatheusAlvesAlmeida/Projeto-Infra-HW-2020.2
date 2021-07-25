module divisor(
    input wire clock,
    input wire reset,
    input wire multOrDiv,
    input signed [31:0] A,
    input signed [31:0] B,
    output reg [31:0] hi, 
    output reg [31:0] lo,
    output reg div0, 
);

reg dividend;
reg divisor;
reg finish;
reg signal;

initial begin
	finish = 0;
	div0 = 0;
    signal = 0;
end

always @(posedge clock) begin
    if(reset = 1'b1) begin
        hi = 32'b0;
		lo = 32'b0;
		divisor = 32'b0;
        dividend = 32'b0;
		finish = 1'b0;
		div0 = 1'b0;
    end
    else if (B == 32'd0 && multOrDiv == 1) begin
        div0 = 1'b1;
    end
    else if (multOrDiv == 1) begin
        dividend = A;
	    divisor = B;
        if(dividend[31] == 1'b1) begin
            dividend = ~dividend + 1;
            signal = 1;
        end
        if(divisor[31] == 1'b1) begin
            divisor = ~divisor + 1;
            if(signal == 0) begin
                signal = 1;
            end
        end
        else if 
    end 
    else if(finish = 0) begin
        for (i = 1; dividend >= divisor; i++) begin
            dividend = dividend - divisor;
            lo = i;
        end
        if(signal == 1) begin
            lo = ~lo + 1;
        end
        hi = dividend;
        finish = 1;
    end
end
endmodule;