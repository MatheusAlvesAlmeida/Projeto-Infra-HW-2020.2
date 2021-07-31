//REVISAR CODIGO E TIRAR O ALUCONTROL E DEIXAR SO O ALUOP
module ctrl_unit (
    input  wire       clk,
    input  wire       reset,
    input  wire       OPCODE,
    output reg        PCWriteCond,
    output reg        PCWrite,
    output reg [1:0]  IorD,
    output reg        MemRead,
    output reg        MemWrite,
    output reg [2:0]  MemToReg,        
    output reg        IRWrite,
    output reg        MultOrDiv,
    output reg        HIWrite,
    output reg        LOWrite,
    output reg [1:0]  Exception,
    output reg [1:0]  DetSizeCtrl,
    output reg [1:0]  SetSizeCtrl,
    output reg        ALUoutputWrite,
    output reg [1:0]  PCSource,
    output reg [2:0]  ALUOp,
    output reg [2:0]  ALUSrcB,
    output reg [1:0]  ALUSrcA,
    output reg        RegWrite,
    output reg        RegDst,
    output reg        EPCWrite,
    output reg [2:0]  ShiftControl,
    output reg [1:0]  ShiftAmt,
    output reg [1:0]  ShiftSrc,
    output reg        WriteA,    
    output reg        WriteB,      
    output reg        WriteAuxA,       
    input  wire       Div0,   
    input  wire       LT,            
    input  wire       GT,              
    input  wire       EG,              
    input  wire       Zero,            
    input  wire       OverfLow
);

// Controladores do estado atual
reg  [5:0] currentState;
reg  [5:0] nextState;
reg  [2:0] cycle;
wire [5:0] auxOffset = offset;

// Todos estados
parameter stateRESET    = 6'd0;
parameter stateCOMMON   = 6'd1;
//parameter stateFETCH    = 6'd2; 
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
//parameter stateLW       = 6'd27;
//parameter stateSW       = 6'd28;
parameter stateSLLM     = 6'd29;
parameter stateADDIU    = 6'd30;
parameter stateADDM     = 6'd31;
//parameter stateLH       = 6'd32;
//parameter stateSH       = 6'd33;
parameter stateDECODE   = 6'd34;
//parameter stateLB       = 6'd35;
//parameter stateSB       = 6'd36;
parameter stateMR       = 6'd37;
parameter stateMW       = 6'd38;
parameter stateLUI      = 6'd39;
parameter stateSRT      = 6'd40;
parameter stateLRT      = 6'd41;
parameter stateLTRT     = 6'd42;
parameter stateLOAD     = 6'd43;
parameter stateSTORE    = 6'd44;

// Opcodes
parameter opcodeR     = 6'b000000;
parameter opcodeADDI  = 6'b001000;
parameter opcodeADDIU = 6'b001001;
parameter opcodeBEQ   = 6'b000100;
parameter opcodeBNE   = 6'b000101;
parameter opcodeBLE   = 6'b000110;
parameter opcodeBGT   = 6'b000111;
parameter opcodeSLLM  = 6'b000001;
parameter opcodeLB    = 6'b100000;
parameter opcodeLH    = 6'b100001;
parameter opcodeLUI   = 6'b001111;
parameter opcodeLW    = 6'b100011;
parameter opcodeSB    = 6'b101000;
parameter opcodeSH    = 6'b101001;
parameter opcodeSLTI  = 6'b001010;
parameter opcodeSW    = 6'b101011;
parameter opcodeJ     = 6'b000010;
parameter opcodeJAL   = 6'b000011;

//Exceções
parameter exceptionOPCODE    = 7'd253;
parameter exceptionOverflow  = 7'd254;
parameter exceptionDivByZero = 7'd255;
parameter waitAndPCwrite     = 6'd35;

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
        currentState <= stateRESET;
        reset = 1'b0;
    end
    else begin
    
        case (currentState)
            stateRESET: begin

                nextState <= stateDECODE;
            end
            // stateCOMMON: begin
                
            // end
            stateDECODE: begin
                //PREENCHER AQUI AS COISAS SOBRE O DECODE
                case (OPCODE)
                    //Coloquem aqui os estados
                    opcodeR: begin
                        case (auxOffset)
                            ADD: begin
                                currentState = stateADD;
                            end
                            AND: begin
                                currentState = stateAND;
                            end
                            SUB: begin
                                currentState = stateSUB;
                            end
                            MULT: begin
                                currentState = stateMULT;
                            end
                            DIV: begin
                                currentState = stateDIV;
                            end
                            MFHI: begin
                                currentState = stateMFHI;
                            end
                            MFLO: begin
                                currentState = stateMFLO;
                            end
                            JR: begin
                                currentState = stateJR;
                            end
                            BREAK: begin
                                currentState = stateBREAK;
                            end
                            RTE: begin
                                currentState = stateRTE;
                            end
                            ADDM: begin
                                currentState = stateADDM;
                            end
                        endcase
                    end

<<<<<<< HEAD
                    default: begin
                        nextstate = exceptionOPCODE;
                    end
=======
            endcase
        end

        stateADD: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                    PCSource       = 2'b00;
                    ALUOp          = 3'b001;// +
                    ALUSrcA        = 2'b01; // A
                    ALUSrcB        = 3'b000;// B
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;    
                end
                3'b001: begin
                    PCWriteCond    = 1'b0;
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b100; //libera o resultado do mux
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b1; //escreve no registrador
                    RegDst         = 2'b00;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end

        stateAND: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                    PCSource       = 2'b00;
                    ALUOp          = 3'b011;// &
                    ALUSrcA        = 2'b01; // A
                    ALUSrcB        = 3'b000;// B
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;    
                end
                3'b001: begin
                    PCWriteCond    = 1'b0;
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b100; //libera o resultado do mux
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b1; //escreve no registrador
                    RegDst         = 2'b00;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end

        stateSUB: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                    PCSource       = 2'b00;
                    ALUOp          = 3'b010;// -
                    ALUSrcA        = 2'b01; // A
                    ALUSrcB        = 3'b000;// B
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;    
                end
                3'b001: begin
                    PCWriteCond    = 1'b0;
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b100; //libera o resultado do mux
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b1; //escreve no registrador
                    RegDst         = 2'b00;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end

        stateDIV: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do div
                    MultOrDiv      = 1'b1;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;    
                end
                3'b001: begin
                    PCWriteCond    = 1'b0;
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do div
                    MultOrDiv      = 1'b1;
                    HiWrite        = 1'b1;
                    LoWrite        = 1'b1;

                    cycle          = cycle + 1;
                    nextState      = currentState;
                end
                3'b010: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do div
                    MultOrDiv      = 1'b1;
                    HiWrite        = 1'b1;
                    LoWrite        = 1'b1;
                    divByZero      = 1'b1;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;
                end
                3'b011: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do div
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

                endcase
            end

            stateADD: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b001;// +
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b100; //libera o resultado do mux
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b1; //escreve no registrador
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
<<<<<<< HEAD
                endcase
            end

            stateAND: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b011;// &
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b100; //libera o resultado do mux
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b1; //escreve no registrador
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end

            stateSUB: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b010;// -
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b100; //libera o resultado do mux
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b1; //escreve no registrador
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end

            stateDIV: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b1;
                        cycle          = cycle + 1;
                        nextState      = currentState;    
=======
                end
            endcase
        end

        stateMULT: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do mult
                    MultOrDiv      = 1'b1;
                    cycle          = cycle + 1;

                    nextState = currentState;
                end
                3'b001: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do mult
                    MultOrDiv      = 1'b1;
                    HiWrite        = 1'b1;
                    LoWrite        = 1'b1;
                    cycle          = cycle + 1;

                    nextState = currentState;
                end
                3'b010: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do mult
                    MultOrDiv      = 1'b1;
                    HiWrite        = 1'b1;
                    LoWrite        = 1'b1;
                    OverfLow       = 1'b1;
                    cycle          = cycle + 1;

                    nextState = currentState;
                end
                3'b011: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    //parte do mult
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    cycle          = 3'b000;
                    if(OverfLow) begin
                        nextState = exceptionOverflow;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b1;
                        HiWrite        = 1'b1;
                        LoWrite        = 1'b1;

                        cycle          = cycle + 1;
                        nextState      = currentState;
                    end
                    3'b010: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b1;
                        HiWrite        = 1'b1;
                        LoWrite        = 1'b1;
                        divByZero      = 1'b0;
                        
                        cycle          = cycle + 1;
                        nextState      = currentState;
                    end
                    3'b011: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;

                        cycle = 3'b000;
                        if (div0) begin
                            divByZero      = 1'b1;
                            nextState = exceptionDivByZero;
                        end
                        else begin
                            nextState = stateCOMMON;
                        end
                    end
                endcase
            end

<<<<<<< HEAD
            stateMULT: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        cycle          = cycle + 1;

                        nextState = currentState;
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b1;
                        LoWrite        = 1'b1;
                        cycle          = cycle + 1;

                        nextState = currentState;
                    end
                    3'b010: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b1;
                        LoWrite        = 1'b1;
                        OverfLow       = 1'b1;
                        cycle          = cycle + 1;

                        nextState = currentState;
                    end
                    3'b011: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        cycle          = 3'b000;
                        if(OverfLow) begin
                            nextState = exceptionOverflow;
                        end
                        else begin
                            nextState = stateCOMMON;
                        end
                    end
                endcase
            end
=======
        stateMFHI: begin
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do mfhi
            MemToReg       = 3'b010;
            RegWrite       = 1'b1;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateMFHI: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do mfhi
                MemToReg       = 3'b010;
                RegWrite       = 1'b1;

                nextState = stateCOMMON;
            end

<<<<<<< HEAD
            stateMFLO: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do mflo
                MemToReg       = 3'b011;
                RegWrite       = 1'b1;

                nextState = stateCOMMON;
            end
=======
        stateMFLO: begin
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do mflo
            MemToReg       = 3'b011;
            RegWrite       = 1'b1;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateJR: begin
                PCWriteCond    = 1'b0; 
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                AluControl     = 3'b000;
                MemToReg       = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do jr
                ALUSrcA        = 2'b01;
                ALUSrcB        = 3'b000;
                ALUOp          = 3'b000;
                //aluoutcontrol#
                PCSource       = 3'b11;
                PCWrite        = 1'b1;

                nextState = stateCOMMON;
            end

<<<<<<< HEAD
            stateBREAK: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1;  //escreve o resultado no ALUOUT
                        PCSource       = 2'b11; //libera o resultado do aluresult para o pc
                        ALUOp          = 3'b010;// -
                        ALUSrcA        = 2'b00; // PC
                        ALUSrcB        = 3'b001;// 4
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b1; //escreve no pc
                        PCWrite        = 1'b1; //escreve no pc
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end
=======
        stateJR: begin
            PCWriteCond    = 1'b0; 
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            MemToReg       = 3'b000;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do jr
            ALUSrcA        = 2'b01;
            ALUSrcB        = 2'b00;
            ALUOp          = 3'b000;
            //aluoutcontrol#
            PCSource       = 3'b11;
            PCWrite        = 1'b1;

            nextState = stateCOMMON;
        end

        stateBREAK: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0;
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b1;  //escreve o resultado no ALUOUT
                    PCSource       = 2'b11; //libera o resultado do aluresult para o pc
                    ALUOp          = 3'b010;// -
                    ALUSrcA        = 2'b00; // PC
                    ALUSrcB        = 3'b001;// 4
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    cycle          = cycle + 1;
                    nextState      = currentState;    
                end
                3'b001: begin
                    PCWriteCond    = 1'b1; //escreve no pc
                    PCWrite        = 1'b1; //escreve no pc
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 2'b00;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end

        stateRTE: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b1; //escreve no pc
                    PCWrite        = 1'b1; //escreve no pc
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00; //EPC
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 3'b000;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end
//==============================================================================conti=====================================================================================
        stateSLL: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b010;
            ShiftAmt = 2'b01;
            ShiftScr = 2'b01;

            nextState = stateSRT;
        end

        sateSRA: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b100;
            ShiftAmt = 2'b01;
            ShiftScr = 2'b01;

            nextState = stateSRT;
        end

        stateSRL: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b011;
            ShiftAmt = 2'b01;
            ShiftScr = 2'b01;

            nextState = stateSRT;
        end

        stateSLLV: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b010;
            ShiftAmt = 2'b00;
            ShiftScr = 2'b00;

            nextState = stateSRT;
        end

        stateSRAV: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b100;
            ShiftAmt = 2'b00;
            ShiftScr = 2'b00;

            nextState = stateSRT;
        end

        stateSLT: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftControl = 3'b000;
            ShiftAmt = 2'b00;
            ShiftScr = 2'b00;

            nextState = stateCOMMON;
        end

//==============================================================================conti=====================================================================================


        //Veriicar 
        stateJUMP: begin
            case (cycle)
                3'b000: begin
                    currentState <= stateDIV;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    //Parte do j#
                    PCWrite        = 1'b1;
                    PCSource       = 2'b10;
                end
                3'b001: begin
                    currentState <= stateJUMP;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    //Parte do j#
                    PCWrite        = 1'b0;
                    PCSource       = 2'b00;
                end
            endcase
        end

        stateBEQ: begin
            case (cycle):
                3'b000: begin
                    currentState <= stateBEQ;
                    PCWrite        = 1'b0;
                    PCSource       = 2'b00;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    //Parte do beq# ciclo 1
                    ALUoutputWrite = 1'b1;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b10;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateRTE: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b1; //escreve no pc
                        PCWrite        = 1'b1; //escreve no pc
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00; //EPC
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end
            //==============================================================================conti=====================================================================================
            stateSLL: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b000
                ALUSrcA = 2'b00
                ALUSrcB = 3'b001
                RegWrite = 1'b1
                RegDst = 1'b1
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0            

                ShiftControl = 3'b010
                ShiftAmt = 2'b01
                ShiftScr = 1'b1

                nextState = stateSRT;
            end

<<<<<<< HEAD
            sateSRA: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b000
                ALUSrcA = 2'b00
                ALUSrcB = 3'b001
                RegWrite = 1'b1
                RegDst = 1'b1
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b100
                ShiftAmt = 2'b01
                ShiftScr = 1'b1

                nextState = stateSRT;
            end

            stateSRL: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b000
                ALUSrcA = 2'b00
                ALUSrcB = 3'b001
                RegWrite = 1'b1
                RegDst = 1'b1
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b011
                ShiftAmt = 2'b01
                ShiftScr = 1'b1

                nextState = stateSRT;
            end

            stateSLLV: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b000
                ALUSrcA = 2'b00
                ALUSrcB = 3'b001
                RegWrite = 1'b1
                RegDst = 1'b1
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b010
                ShiftAmt = 2'b00
                ShiftScr = 1'b0

                nextState = stateSRT;
            end

            stateSRAV: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b000
                ALUSrcA = 2'b00
                ALUSrcB = 3'b001
                RegWrite = 1'b1
                RegDst = 1'b1
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b100
                ShiftAmt = 2'b00
                ShiftScr = 1'b0

                nextState = stateSRT;
            end

            stateSLT: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b101
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b111
                ALUSrcA = 2'b01
                ALUSrcB = 3'b000
                RegWrite = 1'b0
                RegDst = 1'b0
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b000
                ShiftAmt = 2'b00
                ShiftScr = 1'b0

                nextState = stateCOMMON;
            end
=======
                3'b001: begin
                    currentState <= stateBEQ;
                    PCWrite        = 1'b0;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    //Parte do beq# ciclo 2
                    ALUSrcA        = 2'b01;
                    ALUSrcB        = 2'b00;
                    ALUOp          = 3'b111;
                    PCSource       = 2'b01;

                    cycle = cycle + 1;
                end
                3'b010: begin
                    currentState <= stateBEQ;
                    if (EG == 1'b1) begin
                        PCWrite     = 1'b1;
                    end
                    nextState <= stateCOMMON;
                end
            endcase      
        end

        stateBNE: begin
            case(cycle)
                3'b000: begin
                    currentState <= stateBNE;
                    PCWrite        = 1'b0;
                    PCSource       = 2'b00;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;

                    //Parte do bneq# ciclo 1
                    ALUoutputWrite = 1'b1;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b10;

                    cycle = cycle + 1;
                3'b001 begin
                    currentState <= stateBNE;
                    PCWrite        = 1'b0;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    //Parte do bneq# ciclo 2
                    ALUSrcA        = 2'b01;
                    ALUSrcB        = 2'b00;
                    ALUOp          = 3'b111;
                    PCSource       = 2'b01;

                    cycle = cycle + 1;
                end
                3'b010: begin
                    currentState <= stateBNE;
                    if (EG == 1'b0) begin
                        PCWrite     = 1'b1;
                    end
                    nextState <= stateCOMMON;
                end
            endcase
        end

        stateBGT: begin
            case (cycle)
                3'b000: begin
                    currentState <= stateBGT;
                    PCWrite        = 1'b0;
                    PCSource       = 2'b00;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;

                    //Parte do bgt# ciclo 1
                    ALUoutputWrite = 1'b1;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b10;

                    cycle = cycle + 1;
                end
                3'b001: begin
                    currentState <= stateBGT;
                    PCWrite        = 1'b0;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    //Parte do bgt# ciclo 2
                    ALUSrcA        = 2'b01;
                    ALUSrcB        = 2'b00;
                    ALUOp          = 3'b111;
                    PCSource       = 2'b01;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateSLLM: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b01
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b100
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b001
                ALUSrcA = 2'b01
                ALUSrcB = 3'b010
                RegWrite = 1'b1
                RegDst = 1'b0
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b010
                ShiftAmt = 2'b10
                ShiftScr = 1'b1

                nextState = stateSRT;
            end

            stateSLTI: begin
                PCWriteCond = 1'b1
                PCWrite = 1'b1
                IorD = 2'b00
                MemRead = 1'b1
                MemWrite = 1'b0
                MemToReg = 3'b101
                IRWrite = 1'b1
                MultOrDiv = 1'b0
                HiWrite = 1'b0
                LoWrite = 1'b0
                Exception = 2'b00
                DetSizeCtrl = 2'b00
                SetSizeCtrl = 2'b00
                ALUoutputWrite = 1'b0
                PCSoruce = 2'b11
                AluControl = 3'b001
                ALUOp = 3'b010
                ALUSrcA = 2'b01
                ALUSrcB = 3'b010
                RegWrite = 1'b1
                RegDst = 1'b0
                EPCWrite = 1'b1
                WriteA = 1'b1
                WriteB = 1'b1
                WriteAuxA = 1'b0
                Div0 = 1'b0
                LT = 1'b0
                GT = 1'b0
                EG = 1'b0
                Zero = 1'b0
                OverfLow = 1'b0

                ShiftControl = 3'b000
                ShiftAmt = 2'b00
                ShiftScr = 1'b0

                nextState = stateLTRT;
            end
    //==============================================================================conti=====================================================================================


            //Veriicar 
            stateJUMP: begin
                case (cycle)
                    3'b000: begin
                        currentState <= stateDIV;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //Parte do j#
                        PCWrite        = 1'b1;
                        PCSource       = 2'b10;
                    end
<<<<<<< HEAD
                    3'b001: begin
                        currentState <= stateJUMP;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //Parte do j#
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                    end
                endcase
            end

            stateBEQ: begin
                case (cycle):
                    3'b000: begin
                        currentState <= stateBEQ;
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //Parte do beq# ciclo 1
                        ALUoutputWrite = 1'b1;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b010;

                        cycle = cycle + 1;

                    3'b001: begin
                        currentState <= stateBEQ;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do beq# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        AluControl     = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
                    3'b010: begin
                        currentState <= stateBEQ;
                        if (EG == 1'b1) begin
                            PCWrite     = 1'b1;
                        end
                        nextState <= stateCOMMON;
                    end
                endcase      
            end
=======
                    nextState <= stateCOMMON;
                end
            endcase
        end

        stateBLE: begin
            case (cycle)
                3'b000 begin
                    currentState <= stateBLE;
                    PCWrite        = 1'b0;
                    PCSource       = 2'b00;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;

                    //Parte do ble# ciclo 1
                    ALUoutputWrite = 1'b1;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b10;

                    cycle = cycle + 1;
                end
                3'b001 begin
                    currentState <= stateBLE;
                    PCWrite        = 1'b0;
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    
                    //Parte do ble# ciclo 2
                    ALUSrcA        = 2'b01;
                    ALUSrcB        = 2'b00;
                    ALUOp          = 3'b111;
                    PCSource       = 2'b01;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateBNE: begin
                case(cycle)
                    3'b000: begin
                        currentState <= stateBNE;
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;

                        //Parte do bneq# ciclo 1
                        ALUoutputWrite = 1'b1;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b010;

                        cycle = cycle + 1;
                    3'b001 begin
                        currentState <= stateBNE;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do bneq# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        AluControl     = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
<<<<<<< HEAD
                    3'b010: begin
                        currentState <= stateBNE;
                        if (EG == 1'b0) begin
                            PCWrite     = 1'b1;
                        end
                        nextState <= stateCOMMON;
                    end
                endcase
            end
=======
                    nextState <= stateCOMMON;
                end
            endcase
        end


        //jal#
        stateJAL: begin
            case (cycle)
                3'b000: begin
                    PCWrite        = 1'b0;
                    PCWriteCond    = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    //Escrever pc+4 em aluout
                    ALUSrcA        = 2'b00;
                    PCSource       = 2'b01;
                    ALUoutputWrite = 1'b1;
                end
                3'b001: begin
                    PCWriteCond    = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    MultOrDiv      = 1'b0;
                    //jump e escrita no reg31
                    PCSource       = 2'b10;
                    ALUoutputWrite = 1'b1;
                    PCWrite        = 1'b1;
                    RegWrite       = 1'b1;
                    MemToReg       = 3'b000;
                    //Errado deve ir para o reg31 *************************************************************************************************************************
                    RegDst         = 1'b0;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateBGT: begin
                case (cycle)
                    3'b000: begin
                        currentState <= stateBGT;
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;

                        //Parte do bgt# ciclo 1
                        ALUoutputWrite = 1'b1;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b010;

                        cycle = cycle + 1;
                    end
                    3'b001: begin
                        currentState <= stateBGT;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do bgt# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        AluControl     = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
                    3'b010: begin
                        currentState <= stateBGT;
                        if (GT == 1'b1) begin
                            PCWrite     = 1'b1;
                        end
                        nextState <= stateCOMMON;
                    end
                endcase
            end

<<<<<<< HEAD
            stateBLE: begin
                case (cycle)
                    3'b000 begin
                        currentState <= stateBLE;
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;

                        //Parte do ble# ciclo 1
                        ALUoutputWrite = 1'b1;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b010;

                        cycle = cycle + 1;
                    end
                    3'b001 begin
                        currentState <= stateBLE;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do ble# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        AluControl     = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
                    3'b010: begin
                        currentState <= stateBLE;
                        if (LT == 1'b0) begin
                            PCWrite     = 1'b1;
                        end
                        nextState <= stateCOMMON;
                    end
                endcase
            end

=======
        stateMAC: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ALUOp          = 3'b001;
            ALUSrcA        = 2'b01;
            ALUSrcB        = 2'b10;
            ALUoutputWrite = 1'b1;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            //jal#
            stateJAL: begin
                case (cycle)
                    3'b000: begin
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //Escrever pc+4 em aluout
                        ALUSrcA        = 2'b00;
                        PCSource       = 2'b01;
                        ALUoutputWrite = 1'b1;
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //jump e escrita no reg31
                        PCSource       = 2'b10;
                        ALUoutputWrite = 1'b1;
                        PCWrite        = 1'b1;
                        RegWrite       = 1'b1;
                        MemToReg       = 3'b000;
                        //Errado deve ir para o reg31 *************************************************************************************************************************
                        RegDst         = 1'b0;

<<<<<<< HEAD
                    end
                    3'b010: begin
                        
                    end
                    3'b011: begin
                        
                    end
                    default: 
                endcase
            end
=======
        stateMR: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            stateMAC: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                AluControl     = 3'b000;  // ?
                ALUOp          = 3'b001;
                ALUSrcA        = 2'b01;
                ALUSrcB        = 3'b010;
                ALUoutputWrite = 1'b1;

                nextState = stateMR;
            end

            stateMR: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                AluControl     = 3'b000;
                ALUoutputWrite = 1'b0;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                IorD           = 2'b01;
                MemRead        = 1'b1;

                if (cycle == 3'b010) begin
                    cycle = 3'b000;
                    case (OPCODE)
                        opcodeSLLM: begin
                            nextState = stateSLLM;
                        end
                        opcodeLW: begin
                            nextState = stateLW;
                        end
                        opcodeLB: begin
                            nextState = stateLB;
                        end
                        opcodeLH: begin
                            nextState = stateLH;
                        end
                        opcodeSB: begin
                            nextState = stateSB;
                        end
                        opcodeSH: begin
                            nextState = stateSH;
                        end
                        opcodeSW: begin
                            nextState = stateSW;
                        end
                    endcase
                end
                else begin
                    cycle = cycle + 1;
                    nextState = currentState;
                end
            end
                    
            stateLOAD: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                SetSizeCtrl    = 2'b00;
                AluControl     = 3'b000;
                ALUoutputWrite = 1'b0;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                case (OPCODE)
                    opcodeLB: begin
                        DetSizeCtrl = 2'b01;
                    end
                    opcodeLH: begin
                        DetSizeCtrl = 2'b10;
                    end
                    opcodeLW: begin
                        DetSizeCtrl = 2'b00;
                    end
                endcase

                nextState = stateLRT;
            end

            stateSTORE: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                AluControl     = 3'b000;
                ALUoutputWrite = 1'b0;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                case (OPCODE)
                    opcodeSB: begin
                        SetSizeCtrl = 2'b01;
                    end
                    opcodeSH: begin
                        SetSizeCtrl = 2'b10;
                    end
                    opcodeSW: begin
                        SetSizeCtrl = 2'b00;
                    end
                endcase

                nextState = stateMW;
            end
<<<<<<< HEAD
=======
            else begin
                cycle = cycle + 1;
                nextState = currentState;
            end
        end
    
        stateSLLM: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftAmt       = 2'b10;
            ShiftScr       = 1'b1;
            ShiftControl   = 3'b010;

            nextState = stateSRT;
        end
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            //Exceções
            exceptionOverflow: begin
                PCWriteCond    = 1'b0;
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                ALUOp          = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do overflow
                AluControl     = 3'b010;
                EPCWrite       = 1'b1;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                MemWrite       = 32'd254;
                
<<<<<<< HEAD
                if (cycle == 3'b001) begin
                    cycle = 3'b000;
                    nextState = waitAndPCwrite;
=======
        stateLOAD: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            case (OPCODE)
                opcodeLB: begin
                    DetSizeCtrl = 2'b01;
                end
                opcodeLH: begin
                    DetSizeCtrl = 2'b10;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c
                end
                else begin
                    cycle = cycle + 1;
                    nextState = currentState;
                end
<<<<<<< HEAD
            end
=======
            endcase

            nextState = stateLRT;
        end

        stateSTORE: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            exceptionOPCODE: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                ALUOp          = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do opcode n x
                AluControl     = 3'b010;
                EPCWrite       = 1'b1;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                MemWrite       = 32'd253;

                if (cycle == 3'b001) begin
                    cycle = 3'b000;
                    nextState = waitAndPCwrite;
                end
                else begin
                    cycle = cycle + 1;
                    nextState = currentState;
                end
<<<<<<< HEAD
            end
=======
            endcase

            nextState = stateMW;
        end

        stateSRT: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            RegDst         = 1'b0;
            RegWrite       = 1'b1;
            MemToReg       = 3'b100;

            nextState = stateCOMMON;
        end

        stateLRT: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            RegDst         = 1'b0;
            RegWrite       = 1'b1;
            MemToReg       = 3'b001;

            nextState = stateCOMMON;
        end

        stateMW: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            MemRead        = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            IorD           = 2'b01;
            MemWrite       = 1'b1;

            if (cycle == 3'b010) begin
                cycle = 3'b000;
                nextState = stateCOMMON;
            end
            else begin
                cycle = cycle + 1;
                nextState = currentState;
            end
        end

        stateLUI: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ShiftAmt       = 2'b11;
            ShiftScr       = 2'b10;
            ShiftControl   = 3'b010;

            nextState = stateSRT;
        end

        stateSTLI: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            ALUSrcA        = 2'b01;
            ALUSrcB        = 2'b10;
            ALUOp          = 3'b010;

            nextState = stateLTRT;
        end

        stateLTRT: begin
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;

            RegDst         = 1'b0;
            RegWrite       = 1'b1;
            MemToReg       = 3'b101;

            nextState = stateCOMMON;
        end

        //Exceções
        exceptionOverflow: begin
            PCWriteCond    = 1'b0;
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            ALUOp          = 3'b000;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do overflow
            ALUOp     = 3'b010;
            EPCWrite       = 1'b1;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b01;
            MemWrite       = 32'd254;
            
            if (cycle == 3'b001) begin
                cycle = 3'b000;
                nextState = waitAndPCwrite;
            end
            else begin
                cycle = cycle + 1;
                nextState = currentState;
            end
        end

        exceptionOPCODE: begin
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do opcode n x
            ALUOp     = 3'b010;
            EPCWrite       = 1'b1;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b01;
            MemWrite       = 32'd253;
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c

            exceptionDivByZero: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HiWrite        = 1'b0;
                LoWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                ALUOp          = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftScr       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                Div0           = 1'b0;
                LT             = 1'b0;
                GT             = 1'b0;
                EG             = 1'b0;
                Zero           = 1'b0;
                OverfLow       = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do div0
                cycle          = 3'b001;
                AluControl     = 3'b010;
                EPCWrite       = 1'b1;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                MemWrite       = 32'd255;
                
                if (cycle == 3'b001) begin
                    cycle = 3'b000;
                    nextState = waitAndPCwrite;
                end
                else begin
                    cycle = cycle + 1;
                    nextState = currentState;
                end
            end

<<<<<<< HEAD
            waitAndPCwrite: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;

                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HiWrite        = 1'b0;
                        LoWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        PCSource       = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftScr       = 1'b0;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        Div0           = 1'b0;
                        LT             = 1'b0;
                        GT             = 1'b0;
                        EG             = 1'b0;
                        Zero           = 1'b0;
                        OverfLow       = 1'b0;
                        MultOrDiv      = 1'b0;
                        cycle          = 3'b000; 
                        //escrevendo em pc
                        ALUSrcA        = 2'b11;
                        PCWrite        = 1'b1;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end
        endcase
    end
=======
        exceptionDivByZero: begin
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            Div0           = 1'b0;
            LT             = 1'b0;
            GT             = 1'b0;
            EG             = 1'b0;
            Zero           = 1'b0;
            OverfLow       = 1'b0;
            MultOrDiv      = 1'b0;
            //parte do div0
            cycle          = 3'b001;
            ALUOp          = 3'b010;
            EPCWrite       = 1'b1;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b01;
            MemWrite       = 32'd255;
            
            if (cycle == 3'b001) begin
                cycle = 3'b000;
                nextState = waitAndPCwrite;
            end
            else begin
                cycle = cycle + 1;
                nextState = currentState;
            end
        end

        waitAndPCwrite: begin
            case (cycle)
                3'b000: begin
                    PCWriteCond    = 1'b0; 
                    PCWrite        = 1'b0;
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcA        = 2'b00;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;

                    cycle          = cycle + 1; 
                    nextState      = currentState;
                end
                3'b001: begin
                    PCWriteCond    = 1'b0; 
                    IorD           = 2'b00;
                    MemRead        = 1'b0;
                    MemWrite       = 1'b0;
                    MemToReg       = 3'b000;
                    IRWrite        = 1'b0;
                    HiWrite        = 1'b0;
                    LoWrite        = 1'b0;
                    Exception      = 1'b0;
                    DetSizeCtrl    = 2'b00;
                    SetSizeCtrl    = 2'b00;
                    ALUoutputWrite = 1'b0;
                    PCSource       = 2'b00;
                    ALUOp          = 3'b000;
                    ALUSrcB        = 2'b00;
                    RegWrite       = 1'b0;
                    RegDst         = 1'b0;
                    EPCWrite       = 1'b0;
                    ShiftControl   = 3'b000;
                    ShiftAmt       = 2'b00;
                    ShiftScr       = 2'b00;
                    WriteA         = 1'b0;
                    WriteB         = 1'b0;
                    WriteAuxA      = 1'b0;
                    Div0           = 1'b0;
                    LT             = 1'b0;
                    GT             = 1'b0;
                    EG             = 1'b0;
                    Zero           = 1'b0;
                    OverfLow       = 1'b0;
                    MultOrDiv      = 1'b0;
                    cycle          = 3'b000; 
                    //escrevendo em pc
                    ALUSrcA        = 2'b11;
                    PCWrite        = 1'b1;

                    cycle          = 3'b000;
                    nextState      = stateCOMMON;
                end
            endcase
        end
    endcase
>>>>>>> 66a70ea9b60763eb735e6d46336cfa8e9b87240c
end

/*
            PCWrite        = 1'b0;
            PCWriteCond    = 1'b0;
            PCSource       = 2'b00;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            MemToReg       = 3'b000;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 2'b00;
            SetSizeCtrl    = 2'b00;
            ALUoutputWrite = 1'b0;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 3'b000;
            RegWrite       = 1'b0;
            RegDst         = 1'b0;
            EPCWrite       = 1'b0;
            ShiftControl   = 3'b000;
            ShiftAmt       = 2'b00;
            ShiftScr       = 2'b00;
            WriteA         = 1'b0;
            WriteB         = 1'b0;
            WriteAuxA      = 1'b0;
            MultOrDiv      = 1'b0;
*/
