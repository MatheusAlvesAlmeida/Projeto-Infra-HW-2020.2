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
    output reg [1:0]  RegDst,          
    output reg        EPCWrite,        
    output reg [2:0]  ShiftControl,        
    output reg [1:0]  ShiftAmt,        
    output reg [2:0]  ShiftSrc,        
    output reg        WriteA,      
    output reg        WriteB,      
    output reg        WriteAuxA,
    output reg        reset_out,
    input  wire       Div0,        
    input  wire       LT,              
    input  wire       GT,              
    input  wire       EG,            
    input  wire       Zero,         
    input  wire       OverfLow,
    input  wire [5:0] Funct
);

// Controladores do estado atual
reg  [5:0] currentState;
reg  [5:0] nextState;
reg  [2:0] cycle;

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
parameter statePCW      = 6'd45;
parameter stateRW       = 6'd46;

parameter stateMAC      = 6'd51;

//Exceções
parameter exceptionOPCODE    = 6'd47;
parameter exceptionOverflow  = 6'd48;
parameter exceptionDiv0 = 6'd49;
parameter waitAndPCwrite     = 6'd50;

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

// Functs
parameter functADD   = 6'b100000;
parameter functAND   = 6'b100100;
parameter functDIV   = 6'b011010;
parameter functMULT  = 6'b011000;
parameter functJR    = 6'b001000;
parameter functMFHI  = 6'b010000;
parameter functMFLO  = 6'b010010;
parameter functSLL   = 6'b000000;
parameter functSLLV  = 6'b000100;
parameter functSLT   = 6'b101010;
parameter functSRA   = 6'b000011;
parameter functSRAV  = 6'b000111;
parameter functSRL   = 6'b000010;
parameter functSUB   = 6'b100010;
parameter functBREAK = 6'b001101;
parameter functRTE   = 6'b010011;
parameter functADDM  = 6'b000101;

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
        reset_out = 1'b0;
    end
    else begin
        case (currentState)
            stateRESET: begin
                nextState <= stateDECODE;
            end

            // ESTADO COMUNS
            stateCOMMON: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                IorD           = 2'b00;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                MemRead        = 1'b1;
                ALUSrcA        = 2'b01;
                ALUSrcB        = 3'b001;
                PCSource       = 2'b11;
                ALUOp          = 3'b001;
                EPCWrite       = 1'b1;

                if (cycle == 3'b010) begin
                    cycle = 3'b000;
                    nextState = currentState;
                end
                else begin
                    cycle = cycle + 1;
                    nextState = statePCW;
                end
            end

            statePCW: begin
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;

                nextState = stateRW;
            end

            stateRW: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                IRWrite        = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;

                case (OPCODE)
                    opcodeR: begin
                        case (Funct)
                            functADD: begin
                                nextState = stateADD;    
                            end

                            functAND: begin
                                nextState = stateAND;
                            end

                            functDIV: begin
                                nextState = stateDIV;
                            end

                            functMULT: begin
                                nextState = stateMULT;
                            end

                            functJR: begin
                                nextState = stateJR;
                            end

                            functMFHI: begin
                                nextState = stateMFHI;
                            end

                            functMFLO: begin
                                nextState = stateMFLO;
                            end

                            functSLL: begin
                                nextState = stateSLL;
                            end

                            functSLLV: begin
                                nextState = stateSLLV;
                            end

                            functSLT: begin
                                nextState = stateSLT;
                            end

                            functSRA: begin
                                nextState = stateSRA;
                            end

                            functSRAV: begin
                                nextState = stateSRAV;
                            end

                            functSRL: begin
                                nextState = stateSRL;
                            end

                            functSUB: begin
                                nextState = stateSUB;
                            end

                            functBREAK: begin
                                nextState = stateBREAK;
                            end

                            functRTE: begin
                                nextState = stateRTE;
                            end

                            functADDM: begin
                                nextState = stateADDM;
                            end
                        endcase
                    end

                    opcodeADDI: begin
                        nextState = stateADDI;
                    end

                    opcodeADDIU: begin
                        nextState = stateADDIU;
                    end

                    opcodeBEQ: begin
                        nextState = stateBEQ;
                    end

                    opcodeBNE: begin
                        nextState = stateBNE;
                    end

                    opcodeBLE: begin
                        nextState = stateBLE;
                    end

                    opcodeBGT: begin
                        nextState = stateBGT;
                    end

                    opcodeSLLM: begin
                        nextState = stateSLLM;
                    end

                    opcodeLB: begin
                        nextState = stateLOAD;
                    end

                    opcodeLH: begin
                        nextState = stateLOAD;
                    end

                    opcodeLUI: begin
                        nextState = stateLUI;
                    end

                    opcodeLW: begin
                        nextState = stateLOAD;
                    end

                    opcodeSB: begin
                        nextState = stateSTORE;
                    end

                    opcodeSH: begin
                        nextState = stateSTORE;
                    end

                    opcodeSLTI: begin
                        nextState = stateSLTI;
                    end

                    opcodeSW: begin
                        nextState = stateSTORE;
                    end

                    default: begin
                        nextState = exceptionOPCODE;
                    end

                endcase
            end


            //INSTRUÇÕES DO TIPO R 
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b001;// +
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;

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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b011;// &
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;

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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b1;
                        HIWrite        = 1'b1;
                        LOWrite        = 1'b1;

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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b1;
                        HIWrite        = 1'b1;
                        LOWrite        = 1'b1;
                        
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do div
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;

                        cycle = 3'b000;
                        if (Div0) begin
                            nextState = exceptionDiv0;
                        end
                        else begin
                            nextState = stateCOMMON;
                        end
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b1;
                        LOWrite        = 1'b1;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b1;
                        LOWrite        = 1'b1;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        //parte do mult
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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

            stateJR: begin
                PCWriteCond    = 1'b0; 
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
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

            stateMFHI: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do mfhi
                MemToReg       = 3'b010;
                RegWrite       = 1'b1;

                nextState = stateCOMMON;
            end

            stateMFLO: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b000;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do mflo
                MemToReg       = 3'b011;
                RegWrite       = 1'b1;

                nextState = stateCOMMON;
            end

            stateSLL: begin
                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;
                IorD           = 2'b00;
                MemRead        = 1'b1;
                MemWrite       = 1'b0;
                MemToReg       = 3'b100;
                IRWrite        = 1'b1;
                MultOrDiv      = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 2'b00;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b11;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                RegWrite       = 1'b1;
                RegDst         = 1'b1;
                EPCWrite       = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;
                WriteAuxA      = 1'b0;

                ShiftControl   = 3'b010;
                ShiftAmt       = 2'b01;
                ShiftSrc       = 2'b01;

                nextState = stateSRT;
            end

            stateSLLV: begin
                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;
                IorD           = 2'b00;
                MemRead        = 1'b1;
                MemWrite       = 1'b0;
                MemToReg       = 3'b100;
                IRWrite        = 1'b1;
                MultOrDiv      = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 2'b00;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b11;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                RegWrite       = 1'b1;
                RegDst         = 1'b1;
                EPCWrite       = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;
                WriteAuxA      = 1'b0;

                ShiftControl   = 3'b010;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;

                nextState = stateSRT;
            end

            stateSLT: begin
                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;
                IorD           = 2'b00;
                MemRead        = 1'b1;
                MemWrite       = 1'b0;
                MemToReg       = 3'b101;
                IRWrite        = 1'b1;
                MultOrDiv      = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 2'b00;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b11;
                ALUOp          = 3'b111;
                ALUSrcA        = 2'b01;
                ALUSrcB        = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;
                WriteAuxA      = 1'b0;

                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;

                nextState = stateCOMMON;
            end

            stateSRA: begin
                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;
                IorD           = 2'b00;
                MemRead        = 1'b1;
                MemWrite       = 1'b0;
                MemToReg       = 3'b100;
                IRWrite        = 1'b1;
                MultOrDiv      = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 2'b00;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b11;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                RegWrite       = 1'b1;
                RegDst         = 1'b1;
                EPCWrite       = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;
                WriteAuxA      = 1'b0;

                ShiftControl   = 3'b100;
                ShiftAmt       = 2'b01;
                ShiftSrc       = 2'b01;

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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 2'b00;
                EPCWrite       = 1'b0;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                ShiftControl   = 3'b100;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;

                nextState = stateSRT;
            end

            stateSRL: begin
                PCWriteCond    = 1'b1;
                PCWrite        = 1'b1;
                IorD           = 2'b00;
                MemRead        = 1'b1;
                MemWrite       = 1'b0;
                MemToReg       = 3'b100;
                IRWrite        = 1'b1;
                MultOrDiv      = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 2'b00;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b11;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
                RegWrite       = 1'b1;
                RegDst         = 1'b1;
                EPCWrite       = 1'b1;
                WriteA         = 1'b1;
                WriteB         = 1'b1;
                WriteAuxA      = 1'b0;

                ShiftControl   = 3'b011;
                ShiftAmt       = 2'b01;
                ShiftSrc       = 2'b01;

                nextState = stateSRT;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b1; //escreve o resultado no ALUOUT
                        PCSource       = 2'b00;
                        ALUOp          = 3'b010;// -
                        ALUSrcA        = 2'b01; // A
                        ALUSrcB        = 3'b000;// B
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;

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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end
            
            stateADDM: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        PCSource       = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b01;
                        ALUOp          = 3'b000;
                        ALUoutputWrite = 1'b1;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        PCSource       = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b00;
                        ALUOp          = 3'b000;
                        ALUoutputWrite = 1'b0;
                        IorD           = 2'b01;
                        MemRead        = 1'b1;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b011: begin //wait
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        PCSource       = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b00;
                        ALUOp          = 3'b000;
                        ALUoutputWrite = 1'b0;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b100: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        SetSizeCtrl    = 2'b00;
                        PCSource       = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b00;
                        ALUOp          = 3'b000;
                        ALUoutputWrite = 1'b0;
                        DetSizeCtrl    = 2'b10;
                        WriteAuxA      = 1'b1;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b101: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        PCSource       = 2'b00;
                        ALUSrcB        = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b00;
                        ALUOp          = 3'b000;
                        ALUoutputWrite = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        WriteAuxA      = 1'b0;
                        SetSizeCtrl    = 2'b01;
                        MemRead        = 1'b1;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                    3'b111: begin
                        PCWriteCond    = 1'b0; 
                        PCWrite        = 1'b0;
                        IorD           = 2'b00;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        PCSource       = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        MultOrDiv      = 1'b0;
                        //parte do addm
                        ALUSrcA        = 2'b10;
                        ALUSrcB        = 3'b100;
                        ALUOp          = 3'b001;
                        ALUoutputWrite = 1'b1;
                        DetSizeCtrl    = 2'b00;
                        WriteAuxA      = 1'b0;
                        SetSizeCtrl    = 2'b00;
                        MemRead        = 1'b0;
                        cycle          = cycle + 1; 
                        nextState      = currentState;
                    end
                endcase
            end



            //INSTRUÇÕES DO TIPO I
            stateADDI: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;  //A
                        ALUOp          = 3'b001; //+
                        ALUSrcB        = 3'b000;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1; //escrever no aluout

                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;
                        ALUOp          = 3'b001;
                        ALUSrcB        = 3'b010; //B -- imediato
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1;

                        if(OverfLow) begin
                            cycle          = 3'b000;
                            nextState = exceptionOverflow;
                        end
                        else begin  
                            cycle          = cycle + 1;
                            nextState      = currentState; 
                        end  
                    end
                    3'b010: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;
                        ALUOp          = 3'b001;
                        ALUSrcB        = 3'b010;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;//passa a saida do ALUOUT
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b1;  //escrever no registrador
                        RegDst         = 2'b11; //libera o registrador rt
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end

            stateADDIU: begin
                case (cycle)
                    3'b000: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;  //A
                        ALUOp          = 3'b001; //+
                        ALUSrcB        = 3'b000;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1; //escrever no aluout

                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b001: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;
                        ALUOp          = 3'b001;
                        ALUSrcB        = 3'b010; //B -- imediato
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1;

                        cycle          = cycle + 1;
                        nextState      = currentState;    
                    end
                    3'b010: begin
                        PCWriteCond    = 1'b0;
                        PCWrite        = 1'b0;
                        ALUSrcA        = 2'b01;
                        ALUOp          = 3'b001;
                        ALUSrcB        = 3'b010;
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;//passa a saida do ALUOUT
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        RegWrite       = 1'b1;  //escrever no registrador
                        RegDst         = 2'b11; //libera o registrador rt
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        ALUoutputWrite = 1'b1;

                        cycle          = 3'b000;
                        nextState      = stateCOMMON;
                    end
                endcase
            end
        
            stateBEQ: begin
                case (cycle)
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        //Parte do beq# ciclo 1
                        ALUoutputWrite = 1'b1;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b010;

                        cycle = cycle + 1;
		    end
                    3'b001: begin
                        currentState <= stateBEQ;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do beq# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        ALUOp          = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
			nextState = currentState;
                    end
                    3'b010: begin
                        currentState <= stateBEQ;
                        if (EG == 1'b1) begin
                            PCWrite     = 1'b1;
                        end
			cycle = 3'b000;
			nextState <= stateCOMMON;
                    end
                endcase      
            end

            stateBNE: begin
                currentState <= stateBNE;
                PCWrite        = 1'b0;
                PCSource       = 2'b00;
                PCWriteCond    = 1'b0; 
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUOp          = 3'b000;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                //Parte do bneq# ciclo 1
                ALUoutputWrite = 1'b1;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b010;

                nextState <= stateCOMMON;
            end

            stateBLE: begin
                case (cycle)
                    3'b000: begin
                        currentState <= stateBLE;
                        PCWrite        = 1'b0;
                        PCSource       = 2'b00;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
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
                    3'b001: begin
                        currentState <= stateBLE;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do ble# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 2'b00;
                        ALUOp          = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
                    3'b010: begin
                        currentState <= stateBLE;
                        PCWrite        = 1'b0;
                        PCWriteCond    = 1'b0; 
                        IorD           = 2'b00;
                        MemRead        = 1'b0;
                        MemWrite       = 1'b0;
                        MemToReg       = 3'b000;
                        IRWrite        = 1'b0;
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                
                        //Parte do ble# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        ALUOp          = 3'b111;
                        PCSource       = 2'b01;

                        cycle = cycle + 1;
                    end
                    3'b011: begin
                        currentState <= stateBLE;
                        if (LT == 1'b0) begin
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        RegWrite       = 1'b0;
                        RegDst         = 1'b0;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
                        
                        //Parte do bgt# ciclo 2
                        ALUSrcA        = 2'b01;
                        ALUSrcB        = 3'b000;
                        ALUOp          = 3'b111;
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

            // Parte de Farani
            stateMAC: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                ALUOp          = 3'b001;
                ALUSrcA        = 2'b01;
                ALUSrcB        = 2'b10;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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
                            nextState = stateLOAD;
                        end
                        opcodeLB: begin
                            nextState = stateLOAD;
                        end
                        opcodeLH: begin
                            nextState = stateLOAD;
                        end
                        opcodeSB: begin
                            nextState = stateSTORE;
                        end
                        opcodeSH: begin
                            nextState = stateSTORE;
                        end
                        opcodeSW: begin
                            nextState = stateSTORE;
                        end
                    endcase
                end
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b01;
                ShiftControl   = 3'b010;

                nextState = stateSRT;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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

            stateSRT: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b10;
                ShiftControl   = 3'b010;

                nextState = stateSRT;
            end

            stateSLTI: begin
                PCWrite        = 1'b0;
                PCWriteCond    = 1'b0;
                PCSource       = 2'b00;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                EPCWrite       = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
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
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;

                RegDst         = 1'b0;
                RegWrite       = 1'b1;
                MemToReg       = 3'b101;

                nextState = stateCOMMON;
            end


            //INSTRUÇÕES DO TIPO J
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUoutputWrite = 1'b0;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 2'b00;
                        RegWrite       = 1'b0;
                        RegDst         = 2'b00;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
                        Exception      = 1'b0;
                        DetSizeCtrl    = 2'b00;
                        SetSizeCtrl    = 2'b00;
                        ALUOp          = 3'b000;
                        ALUSrcA        = 2'b00;
                        ALUSrcB        = 3'b000;
                        EPCWrite       = 1'b0;
                        ShiftControl   = 3'b000;
                        ShiftAmt       = 2'b00;
                        ShiftSrc       = 2'b00;
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
                        RegDst         = 2'b00;

                        nextState <= stateCOMMON;
                    end
                endcase
            end

            //EXCEPTIONS
            exceptionOverflow: begin
                PCWriteCond    = 1'b0;
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do overflow
                ALUOp          = 3'b010;
                EPCWrite       = 1'b1;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 3'b001;
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
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do opcode n x
                ALUOp          = 3'b010;
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
            end

            exceptionDiv0: begin
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                HIWrite        = 1'b0;
                LOWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 2'b00;
                SetSizeCtrl    = 2'b00;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                RegWrite       = 1'b0;
                RegDst         = 1'b0;
                ShiftControl   = 3'b000;
                ShiftAmt       = 2'b00;
                ShiftSrc       = 2'b00;
                WriteA         = 1'b0;
                WriteB         = 1'b0;
                WriteAuxA      = 1'b0;
                MultOrDiv      = 1'b0;
                //parte do Div0
                cycle          = 3'b001;
                ALUOp          = 3'b010;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
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
                        HIWrite        = 1'b0;
                        LOWrite        = 1'b0;
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
                        ShiftSrc       = 2'b00;
                        WriteA         = 1'b0;
                        WriteB         = 1'b0;
                        WriteAuxA      = 1'b0;
                        MultOrDiv      = 1'b0;
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
end

endmodule
