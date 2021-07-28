module ControlUnity_(
    input wire clk,
    input wire reset, 
    input wire OPCODE, 
    input wire Overflow,
    input wire Zero,
    input wire LT,
    input wire GT,
    input wire Div0, 
    input wire IRWrite,
    input wire RegDst,
    input wire RegWrite,
    input wire WriteA,
    input wire WriteB,
    input wire ALUSrcA,
    input wire ALUSrcB,
    input wire ALUOp,
    input wire EPCWrite,
    input wire PCSource,
    input wire PCWrite,
    input wire MemToReg
);

// Controladores do estado atual
reg [5:0] currentState;
reg [5:0] nextState;
// Todos estados
parameter stateRESET    = 6'd0;
parameter stateCOMMON   = 6'd1;
parameter stateFETCH    = 6'd2; 
parameter stateADD      = 6'd3; 
parameter stateADDI     = 6'd4; 
parameter stateSUB      = 6'd5; 
parameter stateBEQ      = 6'd6; 
parameter stateBNE      = 6'd7; 
parameter stateBLE      = 6'd8; 
parameter stateBGT      = 6'd9; 
parameter stateAND      = 6'd10;
parameter stateDIV      = 6'd11;
parameter stateMULT     = 6'd12;
parameter stateRTE      = 6'd13;
parameter stateJR       = 6'd14;
parameter stateSLL      = 6'd15;
parameter stateSLLV     = 6'd16;
parameter stateSRA      = 6'd17;
parameter stateSRAV     = 6'd18;
parameter stateSRL      = 6'd19;
parameter stateSLT      = 6'd20;
parameter stateSLTI     = 6'd21;
parameter stateBREAK    = 6'd22;
parameter stateMFHI     = 6'd23;
parameter stateMFLO     = 6'd24;
parameter stateJUMP     = 6'd25;
parameter stateJAL      = 6'd26;
parameter stateLW       = 6'd27;
parameter stateSW       = 6'd28;
parameter stateADDIU    = 6'd30;
parameter stateADDM     = 6'd31;
parameter stateADDM     = 6'd32;
parameter stateADDM     = 6'd33;
parameter stateDECODE   = 6'd34;

//Exceções
parameter opcodeNX      = 7'd253;
parameter overflow      = 7'd254;
parameter divByZero     = 7'd255;

initial begin
		nextState <= stateRESET;
end

always @(posedge clk or posedge reset) begin
    if (reset) 
        currentState <= stateRESET;
    else
        currentState <= nextState;
end

//coloquem aq os estados à medida que forem implementando, não vou colocar todos de uma vez. Obg!
always @(negedge clk) begin
    if(reset) begin
        currentState = stateRESET;

    end
    else begin
        case (currentState)
        stateRESET: begin
            
        end
        stateFETCH: begin
            
        end
        stateDECODE begin
            case (OPCODE) begin
                //Coloquem aqui os estados
                default: begin
                    nextstate <= opcodeNX;
                end
            end
        end
    end
    
end