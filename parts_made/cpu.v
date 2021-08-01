module cpu (
    input wire clk,
    input wire reset
);
    // control wires
    wire       PCWriteCond;
    wire       PCWrite;
    wire [1:0] IorD;
    wire       MemRead;
    wire       MemWrite;
    wire [2:0] MemToReg;
    wire       IRWrite;
    wire       MultOrDiv;
    wire       HIWrite;
    wire       LOWrite;
    wire [1:0] Exception;
    wire [1:0] DetSizeCtrl;
    wire [1:0] SetSizeCtrl;
    wire       doConcatenate;
    wire       ALUOutWrite;
    wire [1:0] PCSource;
    wire [2:0] ALUOp;
    wire [2:0] ALUSrcB;
    wire [1:0] ALUSrcA;
    wire       RegWrite;
    wire [2:0] RegDst;
    wire       EPCWrite;
    wire [1:0] ShiftControl;
    wire [1:0] ShiftAmt;
    wire [1:0] ShiftSrc;
    wire       WriteA;
    wire       WriteB;
    wire       WriteAuxA;

    // control flags
    wire       Div0;
    wire       LT;
    wire       GT;
    wire       EG;
    wire       Zero;
    wire       OverfLow;

    // data wires
    //Instructions
    wire [25:0] instructions;
    wire [15:0] inst_0_15;
    wire [4:0]  inst_16_20;
    wire [4:0]  inst_6_10;
    wire [4:0]  inst_21_25;
    wire [5:0]  inst_26_31;
    // MUXS
    wire [31:0] mux_A_ULA_output;
    wire [31:0] mux_B_ULA_output;
    wire [31:0] mux_EXCEPTIONS_output;
    wire [31:0] mux_HI_output;
    wire [31:0] mux_IR_REGISTERS_output;
    wire [31:0] mux_LO_output;
    wire [31:0] mux_MEMORY_REGISTERS_output;
    wire [31:0] mux_PC_MEMORY_output;
    wire [4:0]  mux_SHIFT_AMT_output;
    wire [31:0] mux_SHIFT_SRC_output;
    //PC/EPC
    wire [31:0] PC_input;
    wire [31:0] PC_output;
    wire [31:0] EPC_output;
    //MEMORY
    wire [31:0] SetSize_output;
    wire [31:0] Memory_output;
    //MEMORY DATA REGISTER
    wire        MemoryDataRegister_write;
    wire [31:0] MemoryDataRegister_output;
    //DETSIZE
    wire [31:0] DetSize_output;
    //SIGN EXTEND 1 -> 32
    wire [31:0] SignExtend_1_32_output;
    //SIGN EXTEND 16 -> 32
    wire [31:0] SignExtend_16_32_output;
    //SHIF LEFT 16 -> 32
    wire [31:0] ShiftLeft_16_32_output;
    //SHIF LEFT 2 up
    wire [31:0] ShifLeft_2_up_output;
    //SHIF LEFT 2 down
    wire [31:0] ShifLeft_2_down_output;
    //IR
    wire [5:0]  OPCODE;
    wire [4:0]  RS;
    wire [4:0]  RT;
    wire [15:0] OFFSET;
    //CONCATENAR
    wire [31:0] concatenar_output;
    //REGISTERS
    wire [31:0] ReadData1_output;
    wire [31:0] ReadData2_output;
    //A
    wire [31:0] A_output;
    //AUX A
    wire [31:0] aux_A_output;
    //B
    wire [31:0] B_output;
    //ULA
    wire [31:0] ALUResult;
    //ALU OUT
    wire [31:0] ALUOut_output;
    //SHIF REG
    wire [31:0] ShifReg_output;
    //MULT/DIV
    wire [31:0] mult_output_HI;
    wire [31:0] mult_output_LO;
    wire [31:0] div_output_HI;
    wire [31:0] div_output_LO;
    wire [31:0] HI_output;
    wire [31:0] LO_output;

    Registrador PC_(
        clk,
        reset,
        PCWrite,
        PC_input,
        PC_output
    );

    Memoria MEM_(
        clk,
        MemWrite,
        MemRead,
        mux_PC_MEMORY_out,
        SetSize_output,
        Memory_output
    );

    Inst_Reg IR_(
        clk,
        reset,
        IRWrite,
        Memory_output,
        OPCODE,
        RS,
        RT,
        OFFSET
    );

    set_size SetSize_(
        SetSizeCtrl,
        B_output,
        MemoryDataRegister_output,
        SetSize_output
    );
    
    Registrador MemDataReg_(
        clk,
        reset,
        load,
        MemoryDataRegister_write,
        Memory_output,
        MemoryDataRegister_output
    );

    det_size DetSize_(
        DetSizeCtrl,
        MemoryDataRegister_output,
        DetSize_output
    );

    sign_extend_1_32 SignExtend_1_32_(
        LT,
        SignExtend_1_32_output
    );

    mult MULT_(
        clk,
        reset,
        MultOrDiv,
        A_output,
        B_output,
        mult_output_HI,
        mult_output_LO
    );

    div DIV_(
        clk,
        reset,
        MultOrDiv,
        A_output,
        B_output,
        div_output_HI,
        div_output_LO,
        Div0
    );

    Registrador HI_(
        clk,
        reset,
        HIWrite,
        mux_HI_output,
        HI_output
    );

    Registrador LO_(
        clk,
        reset,
        LOWrite,
        mux_LO_output,
        LO_output
    );

    Registrador A_(
        clk,
        reset,
        WriteA,
        ReadData1_output,
        A_output
    );

    Registrador AuxA_(
        clk,
        reset,
        WriteAuxA,
        MemoryDataRegister_output,
        aux_A_output
    );

    Registrador B_(
        clk,
        reset,
        WriteB,
        ReadData2_output,
        B_output
    );

    mux_A_ULA muxA_(
        ALUSrcA,
        PC_output,
        A_output,
        aux_A_output,
        mux_A_ULA_output
    );

    mux_B_ULA muxB_(
        ALUSrcB,
        B_output,
        SignExtend_16_32_output,
        ShifLeft_2_down_output,
        MemoryDataRegister_output,
        mux_B_ULA_output
    );

    mux_EXCEPTIONS muxExceptions_(
        Exception,
        mux_EXCEPTIONS_output
    );

    mux_HI muxHI_(
        MultOrDiv,
        mult_output_HI,
        div_output_HI,
        mux_HI_output
    );

    mux_IR_REGISTERS muxIrReg_(
        RegDst,
        inst16_20,
        inst0_15,
        mux_IR_REGISTERS_output
    );

    mux_LO muxLO_(
        MultOrDiv,
        mult_output_LO,
        div_output_LO,
        mux_LO_output
    );

    mux_MEMORY_REGISTERS muxMemReg_(
        MemToReg,
        ALUOut_output,
        DetSize_output,
        HI_output,
        LO_output,
        ShifReg_output,
        SignExtend_1_32_output,
        mux_MEMORY_REGISTERS_output
    );

    mux_PC_MEMORY muxPCMemory_(
        IorD,
        PC_output,
        ALUOut_output,
        mux_EXCEPTIONS_output,
        mux_PC_MEMORY_output
    );

    mux_SHIFT_AMT muxShiftAmt_(
        ShiftAmt,
        B_output,
        inst_6_10,
        MemoryDataRegister_output,
        mux_SHIFT_AMT_output
    );

    mux_SHIFT_SRC muxShiftSrc_(
        ShiftSrc,
        A_output,
        B_output,
        mux_SHIFT_SRC_output
    );

    mux_ULA_PC muxULAPC_(
        PCSource,
        EPC_output,
        ALUOut_output,
        concatenar_output,
        ALUResult,
        PC_input
    );

    RegDesloc regDesloc_(
        clk,
        reset,
        ShiftControl,
        mux_SHIFT_SRC_output,
        mux_SHIFT_AMT_output,
        ShifReg_output
    );

    Registrador ALUOut_(
        clk,
        reset,
        ALUOutWrite,
        ALUResult,
        ALUOut_output
    );

    concatenate concatenar_(
        doConcatenate,
        ShifLeft_2_up_output,
        PC_output,
        concatenar_output
    );

    Registrador EPC_(
        clk,
        reset,
        EPCWrite,
        PC_output,
        EPC_output
    );
    
    ula32 ULA_(
        ALUOp,
        mux_A_ULA_output,
        mux_B_ULA_output,
        Overflow,
        LT,
        GT,
        Zero,
        ALUResult
    );

    shift_left_2_up shiftLeft2Up_(
        instructions,
        ShifLeft_2_up_output
    );

    shift_left_2_down shiftLeft2Down_(
        SignExtend_16_32_output,
        ShifLeft_2_down_output
    );

    signExtend_16_32 signExtend16_32_(
        inst_6_10,
        SignExtend_16_32_output
    );

    Banco_reg Registers_(
        clk,
        reset,
        RegWrite,
        inst_21_25,
        inst_16_20,
        mux_IR_REGISTERS_output,
        mux_MEMORY_REGISTERS_output,
        ReadData1_output,
        ReadData2_output
    );
    
    ctrl_unit_(clk, reset, OPCODE, PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemToReg, IRWrite, MultOrDiv, HIWrite, LOWrite, Exception, DetSizeCtrl, SetSizeCtrl, ALUOutWrite, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, EPCWrite, ShiftControl, ShiftAmt, ShiftSrc, WriteA, WriteB, WriteAuxA, reset, DIV0, LT, GT, EG, Zero, OverfLow, OFFSET[5:0]);

endmodule
