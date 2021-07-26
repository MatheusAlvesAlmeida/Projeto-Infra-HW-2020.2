module cpu (
    input wire clk,
    input wire reset,
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
    wire       ALUoutputWrite;
    wire [1:0] PCSource;
    wire [2:0] ALUOp;
    wire [2:0] ALUSrcB;
    wire [1:0] ALUSrcA;
    wire       RegWrite;
    wire       RegDst;
    wire       EPCWrite;
    wire [1:0] ShiftControl;
    wire [1:0] ShiftAmt;
    wire       ShiftSrc;
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
    wire MemoryDataRegister_write;
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
    wire        LT;
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
        PC_output,
    );

    Memoria MEM_(
        clk,
        MemWrite,
        MemRead,
        mux_PC_MEMORY_out,
        SetSize_output,
        Memory_output,
    );

    Inst_Reg IR_(
        clk,
        reset,
        IRWrite,
        Memory_output,
        OPCODE,
        RS,
        RT,
        OFFSET,
    );

    //SETSIZE falta a definição em vhdl
    SETSIZE(
        SetSizeCtrl,
        B_output,
        MemoryDataRegister_output,
        SetSize_output
    );
    
    //Memory data register
    Registrador MemDataReg(
        clk,
        reset,
        load,
        MemoryDataRegister_write,
        Memory_output,
        MemoryDataRegister_output
    );

    //Falta a definição >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    DetSize(
        DetSizeCtrl,
        MemoryDataRegister_output,
        DetSize_output
    );

    //Sign-extend 1-32, falta definir >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    SignExtend_1_32(
        LT,
        SignExtend_1_32_output
    );

    //Mult e div
    mult Mult(
        clk,
        reset,
        MultOrDiv,
        A_output,
        B_output,
        mult_output_HI,
        mult_output_LO,
        Controle
    );
    div Div(
        clk,
        reset,
        MultOrDiv,
        A_output,
        B_output,
        div_output_HI,
        div_output_LO,
        Div0
    );


    //Falta definir HI e LO ???????? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>......
    HI(
        HIWrite,
        mux_HI_output
    );
    LO(
        LOWrite,
        mux_LO_output
    );






    ControlUnity_(clk, reset, OPCODE, Overflow, Zero, LT, GT, Div0, IRWrite, RegDst, RegWrite, WriteA, WriteB,  ALUSrcA, ALUSrcB, ALUOp, EPCWrite, PCSource, PCWrite, MemToReg);

endmodule