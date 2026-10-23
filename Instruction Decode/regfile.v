`timescale 1ns / 1ps

module registerFile(
    input wire clk,
    input wire rst,
    input wire regWrite,
    input wire [4:0] readReg1,
    input wire [4:0] readReg2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    output wire [31:0] readData1,
    output wire [31:0] readData2
);

// 32 registers, each 32 bits wide
reg [31:0] registers [0:31];

integer i;

// Write operation and reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'b0;
    end
    else if (regWrite && writeReg != 5'd0) begin
        registers[writeReg] <= writeData;
    end
end

// Read operations
assign readData1 = registers[readReg1];
assign readData2 = registers[readReg2];

endmodule