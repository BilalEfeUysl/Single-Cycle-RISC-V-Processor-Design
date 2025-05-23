module Extend(
    input  [31:7] Instr,
    input  [1:0]  ImmSrc,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case(ImmSrc)
            2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]}; // I-type
            2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // S-type
            2'b10: ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-type
            2'b11: ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0}; // J-type
            default: ImmExt = 32'b0;
        endcase
    end

endmodule
