module Mux2(
    input  [31:0] D0,
    input  [31:0] D1,
    input         S,
    output [31:0] Y
);

    assign Y = S ? D1 : D0;

endmodule
