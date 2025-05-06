module RegisterFile(
    input         clk,
    input         WE3,
    input  [4:0]  A1, A2, A3,
    input  [31:0] WD3,
    output [31:0] RD1, RD2
);

    reg [31:0] rf[0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            rf[i] = 32'b0;
    end

    always @(posedge clk) begin
        if (WE3 && (A3 != 0))
            rf[A3] <= WD3;
    end

    assign RD1 = (A1 != 0) ? rf[A1] : 32'b0;
    assign RD2 = (A2 != 0) ? rf[A2] : 32'b0;

endmodule
