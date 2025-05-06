module ControlUnit(
    input  [6:0] op,
    input  [2:0] funct3,
    input        funct7,
    output       RegWrite,
    output [1:0] ResultSrc,
    output       MemWrite,
    output       ALUSrc,
    output [1:0] ImmSrc,
    output [2:0] ALUControl,
    output       PCSrc
);

    reg [10:0] controls;

    assign {RegWrite, ResultSrc, MemWrite, ALUSrc, ImmSrc, ALUControl, PCSrc} = controls;

    always @(*) begin
        case(op)
            7'b0110011: // R-type
                case(funct3)
                    3'b000: controls = funct7 ? 11'b1_00_0_0_00_001_0 : 11'b1_00_0_0_00_000_0; // SUB/ADD
                    3'b001: controls = 11'b1_00_0_0_00_101_0; // ✅ SLL
                    3'b111: controls = 11'b1_00_0_0_00_010_0; // AND
                    3'b110: controls = 11'b1_00_0_0_00_011_0; // OR
                    3'b010: controls = 11'b1_00_0_0_00_100_0; // SLT
                    default: controls = 11'b0_00_0_0_00_000_0;
                endcase
            7'b0010011: // I-type
                case(funct3)
                    3'b000: controls = 11'b1_00_0_1_00_000_0; // ADDI
                    3'b111: controls = 11'b1_00_0_1_00_010_0; // ANDI
                    3'b110: controls = 11'b1_00_0_1_00_011_0; // ORI
                    3'b010: controls = 11'b1_00_0_1_00_100_0; // SLTI
                    default: controls = 11'b0_00_0_0_00_000_0;
                endcase
            7'b0000011: controls = 11'b1_01_0_1_00_000_0; // LW
            7'b0100011: controls = 11'b0_00_1_1_01_000_0; // SW
            7'b1100011: controls = 11'b0_00_0_0_10_001_1; // BEQ
            7'b1101111: controls = 11'b1_10_0_1_10_000_1; // JAL
            7'b0110111: controls = 11'b1_11_0_1_11_000_0; // ✅ LUI
            default: controls = 11'b0_00_0_0_00_000_0;
        endcase
    end

endmodule
