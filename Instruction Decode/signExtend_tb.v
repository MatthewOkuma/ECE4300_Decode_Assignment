`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 01:29:28 PM
// Design Name: 
// Module Name: signExtend_tb
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


module signExtend_tb(
    );
    
    reg [15:0] imm;
    wire [31:0] ext;
    
    signExtend DUT(
        .immediate(imm),
        .extended(ext)
        );
        
        initial
            begin
                imm = 16'b1000000000000011;
                #1;
                imm = 16'b1000000000110000;
                #1;
                imm = 16'b0000000001111111;
                #1;
                imm = 16'b0000000001110011;
                #1;
                $display("Test Complete");
                $finish;
            end
            
        initial
            begin
                $monitor("Time=%0t imm=%b ext=%b",
                        $time, imm, ext);
            end    
    
endmodule
