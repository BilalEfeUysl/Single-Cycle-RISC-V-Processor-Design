module Datapath(
    input         clk,
    input         reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    output        MemWrite,
    input  [31:0] ReadData
);

    wire [31:0] PCNext;
    wire [31:0] PCPlus4;
    wire [31:0] ImmExt;
    wire [4:0]  A1, A2, A3;
    wire [31:0] RD1, RD2;
    wire [31:0] SrcA, SrcB;
    wire [2:0]  ALUControl;
    wire        Zero;
    wire [1:0]  ResultSrc;
    wire        ALUSrc;
    wire        RegWrite;
    wire [1:0]  ImmSrc;
    wire        PCSrc;
    wire [31:0] Result;

    // --- PC ---
    PC pc_reg(
        .clk(clk),
        .reset(reset),
        .PCWrite(1'b1),
        .PCNext(PCNext),
        .PC(PC)
    );

    assign PCPlus4 = PC + 4;

    // --- Extend ---
    Extend imm_extender(
        .Instr(Instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // --- Register File ---
    assign A1 = Instr[19:15];
    assign A2 = Instr[24:20];
    assign A3 = Instr[11:7];

    RegisterFile reg_file(
        .clk(clk),
        .WE3(RegWrite),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    // --- ALU girişleri ---
    assign SrcA = RD1;

    Mux2 alu_src_mux(
        .D0(RD2),
        .D1(ImmExt),
        .S(ALUSrc),
        .Y(SrcB)
    );

    ALU alu_inst(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    assign WriteData = RD2;

    wire [31:0] ResultSrc0 = ALUResult;
    wire [31:0] ResultSrc1 = ReadData;
    wire [31:0] ResultSrc2 = PCPlus4;

    assign Result =
        (ResultSrc == 2'b00) ? ResultSrc0 :
        (ResultSrc == 2'b01) ? ResultSrc1 :
        (ResultSrc == 2'b10) ? ResultSrc2 :
        ImmExt; // ✅ ResultSrc == 11 ➔ LUI

    assign PCNext = (PCSrc) ? (PC + ImmExt) : PCPlus4;

    ControlUnit control_unit(
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc)
    );

endmodule
