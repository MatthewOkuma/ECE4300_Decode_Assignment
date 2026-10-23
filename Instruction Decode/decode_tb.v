`timescale 1ns / 1ps

// Instruction Decode Stage Testbench
module decode_tb;

// Testbench inputs
reg clk;
reg rst;
reg wb_reg_write;
reg [4:0] wb_write_reg_location;
reg [31:0] mem_wb_write_data;
reg [31:0] if_id_instr;
reg [31:0] if_id_npc;

// Testbench outputs
wire [1:0] id_ex_wb;
wire [2:0] id_ex_mem;
wire [3:0] id_ex_execute;
wire [31:0] id_ex_npc;
wire [31:0] id_ex_readdat1;
wire [31:0] id_ex_readdat2;
wire [31:0] id_ex_sign_ext;
wire [4:0] id_ex_instr_bits_20_16;
wire [4:0] id_ex_instr_bits_15_11;

// Instantiate Decode module
decode uut(
    .clk(clk),
    .rst(rst),
    .wb_reg_write(wb_reg_write),
    .wb_write_reg_location(wb_write_reg_location),
    .mem_wb_write_data(mem_wb_write_data),
    .if_id_instr(if_id_instr),
    .if_id_npc(if_id_npc),
    .id_ex_wb(id_ex_wb),
    .id_ex_mem(id_ex_mem),
    .id_ex_execute(id_ex_execute),
    .id_ex_npc(id_ex_npc),
    .id_ex_readdat1(id_ex_readdat1),
    .id_ex_readdat2(id_ex_readdat2),
    .id_ex_sign_ext(id_ex_sign_ext),
    .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
    .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
);

// Clock generation
// Clock period = 10 ns
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Display output values
initial begin
    $monitor(
        "Time=%0t rst=%b Instr=%h NPC=%h WB=%b MEM=%b EX=%b Read1=%h Read2=%h SignExt=%h",
        $time, rst, if_id_instr, id_ex_npc,
        id_ex_wb, id_ex_mem, id_ex_execute,
        id_ex_readdat1, id_ex_readdat2,
        id_ex_sign_ext
    );
end

// Test sequence
initial begin

    // Initialize inputs
    rst = 1;
    wb_reg_write = 0;
    wb_write_reg_location = 0;
    mem_wb_write_data = 0;
    if_id_instr = 0;
    if_id_npc = 0;

    // Release reset
    #12 rst = 0;

    // ----------------------------------------
    // Test 1: Write 100 into register 5
    // ----------------------------------------
    @(negedge clk);
    wb_reg_write = 1;
    wb_write_reg_location = 5'd5;
    mem_wb_write_data = 32'd100;

    // Allow rising edge to write register
    @(negedge clk);

    // ----------------------------------------
    // Test 2: Write 200 into register 8
    // ----------------------------------------
    wb_write_reg_location = 5'd8;
    mem_wb_write_data = 32'd200;

    // Allow rising edge to write register
    @(negedge clk);

    // Disable write-back
    wb_reg_write = 0;

    // ----------------------------------------
    // Test 3: R-Type Instruction
    // opcode = 000000
    // rs = 5, rt = 8, rd = 10
    // ----------------------------------------
    if_id_instr = {
        6'b000000,  // R-Type opcode
        5'd5,       // rs
        5'd8,       // rt
        5'd10,      // rd
        5'd0,       // shamt
        6'b100000   // ADD function
    };

    if_id_npc = 32'd4;

    @(posedge clk);
    #1;

    // ----------------------------------------
    // Test 4: Load Word (LW)
    // opcode = 100011
    // rs = 5, rt = 8, immediate = 12
    // ----------------------------------------
    @(negedge clk);

    if_id_instr = {
        6'b100011,  // LW opcode
        5'd5,       // rs
        5'd8,       // rt
        16'd12      // Immediate
    };

    if_id_npc = 32'd8;

    @(posedge clk);
    #1;

    // ----------------------------------------
    // Test 5: Store Word (SW)
    // opcode = 101011
    // rs = 5, rt = 8, immediate = 16
    // ----------------------------------------
    @(negedge clk);

    if_id_instr = {
        6'b101011,  // SW opcode
        5'd5,       // rs
        5'd8,       // rt
        16'd16      // Immediate
    };

    if_id_npc = 32'd12;

    @(posedge clk);
    #1;

    // ----------------------------------------
    // Test 6: Branch Equal (BEQ)
    // opcode = 000100
    // rs = 5, rt = 8, immediate = -4
    // ----------------------------------------
    @(negedge clk);

    if_id_instr = {
        6'b000100,  // BEQ opcode
        5'd5,       // rs
        5'd8,       // rt
        16'hFFFC    // Immediate = -4
    };

    if_id_npc = 32'd16;

    @(posedge clk);
    #1;

    // ----------------------------------------
    // Test 7: Disable Register Writing
    // ----------------------------------------
    @(negedge clk);

    wb_reg_write = 0;
    wb_write_reg_location = 5'd5;
    mem_wb_write_data = 32'd500;

    @(posedge clk);
    #1;

    // ----------------------------------------
    // Test 8: Reset Decode Stage
    // ----------------------------------------
    @(negedge clk);
    rst = 1;

    #2;

    // Release reset
    rst = 0;

    @(posedge clk);
    #1;

    // End simulation
    #10 $finish;

end

endmodule