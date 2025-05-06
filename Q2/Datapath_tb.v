`timescale 1ns/1ps

module Datapath_tb;

    reg         clk;
    reg         reset;
    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    wire        MemWrite;
    wire [31:0] ReadData;

    reg [31:0] instr_mem [0:255];
    reg [31:0] data_mem [0:255];
    integer i;

    // --- Datapath instance ---
    Datapath uut(
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .ReadData(ReadData)
    );

    // --- Instruction Memory bağlama ---
    assign Instr = instr_mem[PC[31:2]];

    // --- Data Memory bağlama ---
    assign ReadData = data_mem[ALUResult[31:2]];

    always @(posedge clk) begin
        if (MemWrite)
            data_mem[ALUResult[31:2]] <= WriteData;
    end

    // --- Clock üretimi ---
    always #5 clk = ~clk;

    // --- Başlangıç ve komut yükleme ---
    initial begin
        clk = 0;
        reset = 1;

        $dumpfile("Datapath_tb.vcd");
        $dumpvars(0, Datapath_tb);

        for (i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'b0;
            data_mem[i] = 32'b0;
        end

        // Program:
        instr_mem[0]  = 32'h00500093; // addi x1, x0, 5
        instr_mem[1]  = 32'h00a00113; // addi x2, x0, 10
        instr_mem[2]  = 32'h002081b3; // add x3, x1, x2
        instr_mem[3]  = 32'h40210233; // sub x4, x2, x1
        instr_mem[4]  = 32'h00302293; // andi x5, x4, 3
        instr_mem[5]  = 32'h00403313; // ori x6, x0, 8
        instr_mem[6]  = 32'h0063a3b3; // slt x7, x7, x6
        instr_mem[7]  = 32'h00302023; // sw x3, 0(x0)
        instr_mem[8]  = 32'h00002303; // lw x6, 0(x0)
        instr_mem[9]  = 32'h00530263; // beq x6, x5, +8
        instr_mem[10] = 32'h07b00193; // addi x3, x0, 123
        instr_mem[11] = 32'h00832313; // ori x6, x6, 8
        instr_mem[12] = 32'h002091b3; // sll x3, x1, x2  (x3 = x1 << x2[4:0])
        instr_mem[13] = 32'h0000006F; // jal x0, 0 (sonsuz döngü)

        #20;
        reset = 0;
    end

    // --- Anlık terminal çıktısı (monitor) ---
    initial begin
        $monitor("TIME=%0t | PC=%h | Instr=%h | ALUResult=%h | WriteData=%h | MemWrite=%b | ReadData=%h", 
                 $time, PC, Instr, ALUResult, WriteData, MemWrite, ReadData);
    end

    // --- Simülasyonu bitirme süresi ---
    initial begin
        #200;
        $finish;
    end

endmodule
