`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2026 10:19:02 AM
// Design Name: 
// Module Name: control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control(
    input wire clk,
    input wire rst,
    input wire [5:0] opcode,
    output reg [1:0] wb,
    output reg [2:0] mem,
    output reg [3:0] ex
    );
    
    parameter RTYPE = 6'b000000;
    parameter LW = 6'b100011;
    parameter SW = 6'b101011;
    parameter BEQ = 6'b000100;
    parameter NOP = 6'b100000;
    
    always @(*)
        begin
            if(rst)
                begin
                    wb = 2'b00;
                    mem = 3'b000;
                    ex = 4'b0000;
                end
            else
                begin
                    case (opcode)
                        RTYPE:              
                            begin
                                ex = 4'b1100;   // RegDst=1, ALUOp1=1, ALUOp0=0, ALUSrc=0
                                mem = 3'b000;   // Branch=0, MemRead=0, MemWrite=0
                                wb = 2'b10;     // RegWrite=1, MemToReg=0
                            end
                        LW   :             
                            begin
                                ex = 4'b0001;   // RegDst=0, ALUOp1=0, ALUOp0=0, ALUSrc=1
                                mem = 3'b010;   // Branch=0, MemRead=1, MemWrite=0
                                wb = 2'b11;     // RegWrite=1, MemToReg=1
                            end    
                        SW   :              
                            begin
                                ex = 4'b0001;   // RegDst=0, ALUOp1=0, ALUOp0=0, ALUSrc=1
                                mem = 3'b001;   // Branch=0, MemRead=0, MemWrite=1
                                wb = 2'b00;     // RegWrite=0, MemToReg=0
                            end    
                        BEQ  :              
                            begin
                                ex = 4'b0010;   // RegDst=0, ALUOp1=0, ALUOp0=1, ALUSrc=0
                                mem = 3'b100;   // Branch=1, MemRead=0, MemWrite=0
                                wb = 2'b00;     // RegWrite=0, MemToReg=0
                            end
                        default:            //NOP
                            begin
                                $display("Opcode not recognized.");
                                ex = 4'b0000;
                                mem = 3'b000;
                                wb = 2'b00;
                            end        
                    endcase
                end    
        end
    
endmodule
