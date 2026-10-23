`timescale 1ns / 1ps

// Register File Testbench
module registerFile_tb;

// Testbench inputs
reg clk;                  // Clock signal
reg rst;                  // Reset signal
reg regWrite;             // Register write enable
reg [4:0] readReg1;       // First register address
reg [4:0] readReg2;       // Second register address
reg [4:0] writeReg;       // Register address to write
reg [31:0] writeData;     // Data to write

// Testbench outputs
wire [31:0] readData1;    // First register output
wire [31:0] readData2;    // Second register output

// Instantiate Register File
registerFile uut(
    .clk(clk),
    .rst(rst),
    .regWrite(regWrite),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);

// Clock generation
// Clock period = 10 ns
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test Register File operation
initial begin

    // Initialize inputs
    rst = 1;
    regWrite = 0;
    readReg1 = 0;
    readReg2 = 0;
    writeReg = 0;
    writeData = 0;

    // Display simulation results
    $monitor("Time=%0t rst=%b regWrite=%b ReadReg1=%d ReadData1=%d ReadReg2=%d ReadData2=%d",
             $time, rst, regWrite,
             readReg1, readData1,
             readReg2, readData2);

    // Release reset
    #12 rst = 0;

    // Test 1: Write 100 into register 5
    writeReg = 5'd5;
    writeData = 32'd100;
    regWrite = 1;

    #10;

    // Test 2: Write 200 into register 8
    writeReg = 5'd8;
    writeData = 32'd200;

    #10;

    // Test 3: Read registers 5 and 8
    regWrite = 0;
    readReg1 = 5'd5;
    readReg2 = 5'd8;

    #10;

    // Test 4: Disable register writing
    writeReg = 5'd5;
    writeData = 32'd500;
    regWrite = 0;

    #10;

    // Test 5: Enable writing to register 10
    regWrite = 1;
    writeReg = 5'd10;
    writeData = 32'd300;

    #10;

    // Test 6: Read registers 10 and 5
    regWrite = 0;
    readReg1 = 5'd10;
    readReg2 = 5'd5;

    #10;

    // Test 7: Reset Register File
    rst = 1;

    #10;

    // Release reset
    rst = 0;

    // Test 8: Read after reset
    readReg1 = 5'd5;
    readReg2 = 5'd10;

    #10;

    // End simulation
    $finish;

end

endmodule