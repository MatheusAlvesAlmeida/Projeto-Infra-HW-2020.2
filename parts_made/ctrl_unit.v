module ControlUnity_(
    input wire clk,
    input wire reset,
    input wire OPCODE,
    input wire       PCWriteCond;
    input wire       PCWrite;     
    input wire [1:0] IorD;        
    input wire       MemRead;         
    input wire       MemWrite;        
    input wire [2:0] MemToReg;        
    input wire       IRWrite;     
    input wire       MultOrDiv;       
    input wire       HIWrite;     
    input wire       LOWrite;     
    input wire [1:0] Exception;       
    input wire [1:0] DetSizeCtrl;     
    input wire [1:0] SetSizeCtrl; 
    input wire       ALUoutputWrite;  
    input wire [1:0] PCSource;        
    input wire [2:0] ALUOp;       
    input wire [2:0] ALUSrcB;     
    input wire [1:0] ALUSrcA;     
    input wire       RegWrite;        
    input wire       RegDst;          
    input wire       EPCWrite;        
    input wire [2:0] ShiftControl;        
    input wire [1:0] ShiftAmt;        
    input wire       ShiftSrc;        
    input wire       WriteA;      
    input wire       WriteB;      
    input wire       WriteAuxA;       
    output wire      Div0;        
    output wire      LT;              
    output wire      GT;              
    output wire      EG;              
    output wire      Zero;            
    output wire      OverfLow;
);

// Controladores do estado atual
reg [5:0] currentState;
reg [5:0] nextState;
wire [5:0] auxOffset = offset;

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
            //PREENCHER AQUI AS COISAS SOBRE O DECODE
            case (OPCODE) begin
                //Coloquem aqui os estados
                rFunctions: begin
                    case(auxOffset) begin
                        mult: begin
                            currentState <= stateMULT;
                        end
                        div: begin
                            currentState <= stateDIV;
                        end
                        mfhi: begin
                            currentState <= stateMFHI
                        end
                        mflo: begin
                            currentState <= stateMFLO
                        end
                        jr: begin
                            currentState <= stateJR
                        end
                    end
                end
                default: begin
                    nextstate <= opcodeNX;
                end
            end
        end

        stateDIV: begin
            reg cycle = 3'b000; 
            if(cycle = 3'b000) begin
                currentState <= stateDIV;
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
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                cycle          = 3'b001;      
            end
            else if(cycle = 3'b001) begin
                currentState <= stateDIV;
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                cycle          = 3'b010;
            end
            else if (cycle = 3'b010) begin
                currentState <= stateDIV;
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                OverfLow       = 1'b1;
                cycle          = 3'b011;
            end
            else if(cycle = 3'b011) begin
                currentState <= stateCOMMON
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                OverfLow       = 1'b0;
                cycle          = 3'b000;
            end
        end
        stateMULT: begin
            reg cycle = 3'b000; 
            if(cycle = 3'b000) begin
                currentState <= stateMULT;
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
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                MultOrDiv      = 1'b1;
                cycle          = 3'b001;      
            end
            else if(cycle = 3'b001) begin
                currentState <= stateMULT;
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                MultOrDiv      = 1'b1;
                HiWrite        = 1'b1;
                LoWrite        = 1'b1;
                cycle          = 3'b010;
            end
            else if (cycle = 3'b010) begin
                currentState <= stateMULT;
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                MultOrDiv      = 1'b1;
                HiWrite        = 1'b1;
                LoWrite        = 1'b1;
                OverfLow       = 1'b1;
                cycle          = 3'b011;
            end
            else if(cycle = 3'b011) begin
                currentState <= stateCOMMON
                PCWriteCond    = 1'b0; 
                PCWrite        = 1'b0;
                IorD           = 2'b00;
                MemRead        = 1'b0;
                MemWrite       = 1'b0;
                MemToReg       = 3'b000;
                IRWrite        = 1'b0;
                Exception      = 1'b0;
                DetSizeCtrl    = 1'b0;
                SetSizeCtrl    = 1'b0;
                ALUoutputWrite = 1'b0;
                PCSource       = 2'b00;
                AluControl     = 3'b000;
                ALUOp          = 3'b000;
                ALUSrcA        = 2'b00;
                ALUSrcB        = 2'b00;
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
                OverfLow       = 1'b0;
                cycle          = 3'b000;
            end
        end
        stateMFHI: begin
            currentState <= stateMFHI;
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 1'b0;
            SetSizeCtrl    = 1'b0;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            AluControl     = 3'b000;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
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
        end
        stateMFLO: begin
            currentState <= stateMFHI;
            PCWriteCond    = 1'b0; 
            PCWrite        = 1'b0;
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 1'b0;
            SetSizeCtrl    = 1'b0;
            ALUoutputWrite = 1'b0;
            PCSource       = 2'b00;
            AluControl     = 3'b000;
            ALUOp          = 3'b000;
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
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
        end
        stateJR: begin
            currentState <= stateJR;
            PCWriteCond    = 1'b0; 
            IorD           = 2'b00;
            MemRead        = 1'b0;
            MemWrite       = 1'b0;
            IRWrite        = 1'b0;
            HiWrite        = 1'b0;
            LoWrite        = 1'b0;
            Exception      = 1'b0;
            DetSizeCtrl    = 1'b0;
            SetSizeCtrl    = 1'b0;
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
            ALUSrcA        = 2'b00;
            ALUSrcB        = 2'b00;
            ALUOp          = 3'b000;
            //aluoutcontrol#
            PCSource       = 2'b00;
            PCWrite        = 1'b0;
        end
    end
    
end