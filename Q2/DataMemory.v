module DataMemory(
    input         clk,
    input         WE,
    input  [31:0] A,
    input  [31:0] WD,
    output [31:0] RD
);

    reg [31:0] RAM [0:255];

    always @(posedge clk) begin
        if (WE)
            RAM[A[31:2]] <= WD;
    end

    assign RD = RAM[A[31:2]];

endmodule
